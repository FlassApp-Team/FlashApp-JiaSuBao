//
//  IFDataService.h
//  flashapp
//
//  Created by 李 电森 on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFData.h"


@interface IFDataService : NSObject

+ (IFData*) readCellFlowData;
+ (NSDictionary*) readInterfacesNetFlow;

@end
