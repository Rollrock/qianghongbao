//
//  GameView.h
//  My2048
//
//  Created by zhuang chaoxiao on 14-5-21.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROW_COUNT 4
#define COLUMN_COUNT 4

typedef enum
{
	MOVE_DIR_UP = 0,
	MOVE_DIR_DOWN = 1,
	MOVE_DIR_LEFT = 2,
	MOVE_DIR_RIGHT = 3
	
}MOVE_DIR;



@interface GameView : UIView

-(void)refreshGameSkin;

@end
