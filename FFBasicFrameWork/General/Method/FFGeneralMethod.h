//
//  FFGeneralMethod.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/3/8.
//  Copyright © 2019 jisa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFGeneralMethod : NSObject

/**
 alert 弹窗系统样式

 @param title <#title description#>
 @param message <#message description#>
 @param sure <#sure description#>
 @param sureBlock <#sureBlock description#>
 @param cancle <#cancle description#>
 @param cancleBlock <#cancleBlock description#>
 */
+ (UIAlertController *)FF_AcquireAlertControllerTitle:(nullable NSString *)title message:(nullable NSString *)message  sureBtn:(nullable NSString *)sure sureBlock:(void(^ __nullable)(void))sureBlock cancleBtn:(nullable NSString *)cancle cancleBlock:(void(^ __nullable)(void))cancleBlock;
@end

NS_ASSUME_NONNULL_END
