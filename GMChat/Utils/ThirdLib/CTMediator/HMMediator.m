#import "HMMediator.h"
#import <objc/message.h>
@implementation MediatorOptions
+(instancetype)setupWithTargetName:(NSString *)targetName actionName:(NSString *)actionName {
    MediatorOptions *options = [[MediatorOptions alloc] init];
    if(options) {
        options.targetName = [NSString stringWithFormat:@"GMChat.Target_%@", targetName];
        options.actionName = [NSString stringWithFormat:@"action_%@:", actionName];
    }
    return  options;
}
@end
@interface HMMediator()
@property(nonatomic,strong) NSMutableDictionary<NSString*, id> *cacheTargetDictionary;
@end
@implementation HMMediator
-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        _cacheTargetDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}
+(instancetype)sharedInstance {
    static HMMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HMMediator alloc] initPrivate];
    });
    return mediator;
}
-(id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary * _Nullable))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    id result = [self performTarget:[NSString stringWithFormat:@"Target_%@",url.host] action:[NSString stringWithFormat:@"action_goto%@:",actionName] params:params shouldCacheTarget:NO cacheTargetKey:nil];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}
-(id)performWithOptions:(MediatorOptions *)options {
    return [self performTarget:options.targetName action:options.actionName params:options.parameters shouldCacheTarget:options.shouldCacheTarget cacheTargetKey:options.cacheKey];
}
-(id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary<NSString *,id> *)params shouldCacheTarget:(BOOL)shouldCacheTarget cacheTargetKey:(NSString *)cacheKey {
    id target;
    if(cacheKey) {
        target = _cacheTargetDictionary[cacheKey];
    }
    if(!target) {
        target = [[NSClassFromString(targetName) alloc] init];
    }
    if(!target) {
        NSLog(@"target does not exist");
        return nil;
    }
    if(shouldCacheTarget) {
        if(cacheKey) {
            [_cacheTargetDictionary setObject:target forKey:cacheKey];
        } else {
            NSLog(@"cacheKey is nil");
            return nil;
        }
    }
    if(!actionName) {
        NSLog(@"actionName is nil");
        return nil;
    }
    SEL action = NSSelectorFromString(actionName);
    if([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    } else {
        NSLog(@"%@ not found", actionName);
        return nil;
    }
}
-(void)removeCacheTargetWithKey:(NSString *)cacheKey {
    [_cacheTargetDictionary removeObjectForKey:cacheKey];
}
+(NSString *)generateCacheKey {
    NSString *key = @"";
    return key;
}
@end
