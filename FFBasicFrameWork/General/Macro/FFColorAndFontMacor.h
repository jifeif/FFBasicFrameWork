//
//  FFColorAndFontMacor.h
//  FFBasicFrameWork
//
//  Created by jisa on 2019/3/8.
//  Copyright © 2019 jisa. All rights reserved.
//

#ifndef FFColorAndFontMacor_h
#define FFColorAndFontMacor_h

#define FontSystem15 [UIFont systemFontOfSize:15]

#define FFColorRGB(A) [UIColor colorWithRed:((A & 0xff0000) >> 16) / 255.0 green:((A & 0x00ff00) >> 8) / 255.0 blue:(A & 0x0000ff) / 255.0 alpha:1.0]
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]

#endif /* FFColorAndFontMacor_h */
