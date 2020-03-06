#import <UIKit/UIKit.h>
@interface MediatorOptions : NSObject
@property(nonnull,nonatomic,strong) NSString *targetName;
@property(nonnull,nonatomic,strong) NSString *actionName;
@property(nullable,nonatomic,strong) NSDictionary<NSString*, id> *parameters;
@property(nonatomic,assign) BOOL shouldCacheTarget;
@property(nullable,nonatomic,strong) NSString *cacheKey;
+(instancetype _Nullable )setupWithTargetName:(NSString *_Nullable)targetName actionName:(NSString *_Nullable)actionName;
@end
@interface HMMediator : NSObject
-(nullable instancetype)init NS_UNAVAILABLE;
+(nullable instancetype)new NS_UNAVAILABLE;
+(nonnull instancetype)sharedInstance;
- (nullable id)performActionWithUrl:(nonnull NSURL *)url completion:(void(^ _Nullable)(NSDictionary * _Nullable info))completion;
-(nullable id)performWithOptions:(nonnull MediatorOptions *)options;
-(void)removeCacheTargetWithKey:(nonnull NSString*)cacheKey;
+(nonnull NSString*)generateCacheKey;
@end
