//
//  NSObject+KVO.m
//  MakeKVO
//
//  Created by LastDays on 16/4/5.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ObserverInfo.h"


NSString *const LYKVOPrefix    = @"LYNewClass_";
NSString *const LYObserverInfo = @"LYObserverInfo";




@implementation NSObject(LYKVO)

-(void)LY_addObserver:(NSObject *)observer forKey:(NSString *)key LYBlock:(LYBlock)lyblock{
    
    
    Class superClass = object_getClass(self);
    NSString *superClassName = NSStringFromClass(superClass);
    
    Class childrenClass;
    if (![superClassName hasPrefix:LYKVOPrefix]) {
        //定义中间类类
        childrenClass =  [self makeChildrenClassWithName:superClassName];
        
        //改变isa指针，指向中间类
        object_setClass(self, childrenClass);
    }
    
    //获取父类的setter
    NSString *superSetterName = [NSString stringWithFormat:@"set%@%@:", [key substringToIndex:1].uppercaseString,[key substringFromIndex:1]];
    SEL setterSelector = NSSelectorFromString(superSetterName);
    Method superSetterMethod = class_getInstanceMethod(superClass, setterSelector);
    
    if (![self isExistence:setterSelector]) {
        //重写setter,改变IMP
        const char *types = method_getTypeEncoding(superSetterMethod);
        class_addMethod(childrenClass, setterSelector,(IMP)lykvo_setter, types);
    }
    
    //添加关联，添加观察者
    ObserverInfo *info = [[ObserverInfo alloc] initWithObserver:observer Key:key lyBlock:lyblock];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)LYObserverInfo);
    if (!observers) {
        observers = [[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, (__bridge const void *)LYObserverInfo, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [observers addObject:info];
    
    
    
}
-(void)LY_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    
}

-(Class)makeChildrenClassWithName:(NSString *)superName{
    
    /**
     *  建立新的类名：我们以LYNewClass_+superName
     */
    NSString *childrenName = [LYKVOPrefix stringByAppendingString:superName];
    
    /**
     *  获取父类
     *
     *  @param self 当前类
     *
     *  @return 返回当前类（也就是中间类的父类）
     */
    Class superClass = object_getClass(self);
    
    /**
     *  动态创建中间类
     *
     *  @param superClass              父类（self）,如果建立根类，可以选择填写nil
     *  @param childrenName.UTF8String 类名
     *  @param 0                       该参数是分配给类和元类对象尾部的索引ivars的字节数。
     *
     *  @return 中间类
     */
    Class childrenClass = objc_allocateClassPair(superClass, childrenName.UTF8String, 0);
    
    /**
     *  获取父类类方法（这里说的父类就是当前类）
     *
     *  @param superClass self
     *  @param class      class
     *
     *  @return  superMethod
     */
    Method superMethod = class_getClassMethod(superClass, @selector(class));
    
    //参数types是一个描述传递给方法的参数类型的字符数组，这就涉及到类型编码
    const char *types = method_getTypeEncoding(superMethod);
    
    //获取函数具体地址
    IMP imp = class_getMethodImplementation(superClass, @selector(class));
    
    /**
     *  向childrenClass添加方法
     *
     *  @param childrenClass 中间类
     *  @param class         class
     *
     *  @return BOOL
     */
    class_addMethod(childrenClass, @selector(class), imp, types);
    
    /**
     *  注册，之后这个新类就可以在程序中使用了
     */
    objc_registerClassPair(childrenClass);
    return childrenClass;
    
}

- (void)PG_removeObserver:(NSObject *)observer forKey:(NSString *)key
{
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(LYObserverInfo));
    
    ObserverInfo *infoToRemove;
    for (ObserverInfo* info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];
}


-(NSString *)getGetterForKeyWithSetterName:(NSString *)name{
    
    NSString *key = [name substringWithRange:NSMakeRange(3, 4)];
    
    NSString *getterName = [NSString stringWithFormat:@"%@%@",[key substringToIndex:1].lowercaseString,[key substringFromIndex:1]];
    
    
    return getterName;
}

- (BOOL)isExistence:(SEL)selector
{
    Class childrenClass = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(childrenClass, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}

#pragma mark - Overridden Methods
void lykvo_setter(id self,SEL _cmd,id value){
    
    
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [self getGetterForKeyWithSetterName:setterName];
    
    SEL getter = NSSelectorFromString(getterName);
    id oldValue = ((id (*)(id, SEL))(void *) objc_msgSend)((id)self,getter);
    
    NSLog(@"oldValue = %@",oldValue);
    /**
     *  向父类发送消息，但是接收消息的仍然是我们的self
     */
    //((void (*)(id, SEL, id))(void *) objc_msgSend)((id)self, _cmd, value);
    struct objc_super superClass = {
            .receiver = self,
            .super_class = class_getSuperclass(object_getClass(self))
        };
    ((void (*)(id, SEL, id))(void *) objc_msgSendSuper)((__bridge id)(&superClass), _cmd, value);
    
    /**
     *  这里就是进行通知了。
     */
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)LYObserverInfo);
    for (ObserverInfo *observer in observers) {
        if ([observer.key isEqual:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                observer.lyBlock(self, getterName, oldValue, value);
            });
        }
    }
    
    
}

@end



