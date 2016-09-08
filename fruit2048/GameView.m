//
//  GameView.m
//  My2048
//
//  Created by zhuang chaoxiao on 14-5-21.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "GameView.h"
#import "MenuViewController.h"
#import "AppDelegate.h"



#define GRID_BG_WIDHT   300.0f
#define GRID_BG_HEIGHT   300.0f

#define PER_GRID_WIDTH  64.0f
#define PER_GRID_HEIGH  64.0f
#define GRID_TIP_X 9.0f
#define GRID_TIP_Y 9.0f


#define SMALLEXT_MOVE_DIS   20

#define GRID_TAG_BASE   10000




@interface GameView()
{
    int dataArray[ROW_COUNT][COLUMN_COUNT];
    int moveArray[ROW_COUNT][COLUMN_COUNT];
    BOOL delArray[ROW_COUNT][COLUMN_COUNT];
    BOOL spEffArray[ROW_COUNT][COLUMN_COUNT];
    
    NSMutableArray * imgArray;
    UIImageView * gridBgView;
    
    CGPoint moveFromPT;
    
    UILabel * labScore;
    
    BOOL touchDown;
    
    int score;
    
    AppDelegate * appDel;
    
    int _skin;
    
}
@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        appDel = [[UIApplication sharedApplication] delegate];
        
        _skin = [appDel getSkin];
        
        [self initData];
        
        [self startGame];
    }
    
    return self;
}


-(void)revertData
{
    for( int i = 0; i < ROW_COUNT; ++ i )
    {
        for( int j = 0; j < COLUMN_COUNT; ++ j )
        {
            moveArray[i][j] = 0;
            delArray[i][j] = NO;
            spEffArray[i][j] = NO;
        }
    }
}


-(void)initData
{
    
    for( int i = 0; i < ROW_COUNT; ++ i )
    {
        for( int j = 0; j < COLUMN_COUNT; ++ j )
        {
            dataArray[i][j] = 0;
            moveArray[i][j] = 0;
            delArray[i][j] = NO;
            spEffArray[i][j] = NO;
        }
    }
    
    
    //初始化背景
    
    CGRect rect = CGRectMake(([UIScreen mainScreen].bounds.size.width-GRID_BG_WIDHT)/2,120,GRID_BG_WIDHT,GRID_BG_HEIGHT);
    
    gridBgView = [[UIImageView alloc]initWithFrame:rect];
    gridBgView.image = [UIImage imageNamed:@"bg"];
    [self addSubview:gridBgView];
    
    //添加title以及icon
    
    rect = CGRectMake(10, 30, 300, 160);
    UIView * bgView = [[UIView alloc]initWithFrame:rect];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    {
        CGRect rect;
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        view.backgroundColor = [UIColor orangeColor];
        view.layer.cornerRadius = 5;
        
        [bgView addSubview:view];
        
        rect = CGRectMake(15, 10, 70, 60);
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"全民\n红包";
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:25];
        lab.backgroundColor = [UIColor clearColor];
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
        
        
        [view addSubview:lab];
    }
    
    {
        CGRect rect = CGRectMake(90, 0, 60, 40);
        
        UIView * view = [[UIView alloc]initWithFrame:rect];
        view.backgroundColor = [UIColor orangeColor];
        view.layer.cornerRadius = 5;
        [bgView addSubview:view];
        
        rect = CGRectMake(0, 2, 60,20);
        UILabel * lab1 = [[UILabel alloc]initWithFrame:rect];
        lab1.backgroundColor = [UIColor clearColor];
        lab1.text = @"金钱";
        lab1.font = [UIFont systemFontOfSize:15];
        lab1.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab1];
        
        
        rect = CGRectMake(0, 18, 60, 20);
        labScore = [[UILabel alloc]initWithFrame:rect];
        labScore.text = @"0";
        labScore.textAlignment = NSTextAlignmentCenter;
        labScore.textColor = [UIColor whiteColor];
        labScore.font = [UIFont systemFontOfSize:15];
        labScore.backgroundColor = [UIColor clearColor];
        [view addSubview:labScore];
        
    }
    
    
    {
        [self addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"score"])
    {
        NSLog(@"score:%@",[self valueForKey:@"score"]);
        
        if( [[self valueForKey:@"score"] isKindOfClass:[NSNumber class]])
        {
            NSString * str = [NSString stringWithFormat:@"%d",[[self valueForKey:@"score"] intValue]];
            
            labScore.text = str;
            
            
            if( ([[self valueForKey:@"score"] intValue] >= 100) && ([[self valueForKey:@"score"] intValue]<= 150))
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWADV" object:nil];
            }
        }

    }
}



-(void)startGame
{
    srand((unsigned)time(0));
    
    int randRow =  rand()  % ROW_COUNT;
    int randColumn = rand()  % COLUMN_COUNT;
    
    
    dataArray[randRow][randColumn] = [self getBaseRandData];
    
    if( randRow % 2 == 0 )
    {
        if( randColumn% 3 == 0 )
        {
            dataArray[(randRow + 1) % ROW_COUNT][(randColumn + 3) % COLUMN_COUNT] = [self getBaseRandData];
        }
        else if( randColumn % 3 == 1 )
        {
            dataArray[(randRow + 2) % ROW_COUNT][(randColumn + 3) % COLUMN_COUNT] = [self getBaseRandData];
        }
        else
        {
            dataArray[(randRow + 3) % ROW_COUNT][(randColumn + 2) % COLUMN_COUNT] = [self getBaseRandData];
        }
        
    }
    else
    {
        if( randColumn% 3 == 0 )
        {
            dataArray[(randRow + 3) % ROW_COUNT][(randColumn + 1) % COLUMN_COUNT] = [self getBaseRandData];
        }
        else if( randColumn % 3 == 1 )
        {
            dataArray[(randRow + 2) % ROW_COUNT][(randColumn + 2) % COLUMN_COUNT] = [self getBaseRandData];
        }
        else
        {
            dataArray[(randRow + 1) % ROW_COUNT][(randColumn + 1) % COLUMN_COUNT] = [self getBaseRandData];
        }
    }
    
    [self drawGame];
   
}


//格子是否充满了
-(bool)isArrayFull
{
	for(int row = 0; row < ROW_COUNT; ++ row)
	{
		for(int column = 0; column < COLUMN_COUNT; ++ column)
		{
			if( dataArray[row][column] == 0 )
			{
				return NO;
			}
		}
	}
	
	return YES;
}


//游戏是否结束
-(bool)isGameOver
{
	if( [self isArrayFull] )
	{
		int row, column;
		
		//竖
		for( column = 0; column < COLUMN_COUNT; ++ column )
		{
			for( row = 0; row < ROW_COUNT-1; ++ row )
			{
				for( int i = row + 1; i < ROW_COUNT; ++ i )
				{
					if( (dataArray[row][column] == dataArray[i][column] ) && (dataArray[row][column]!=0))
					{
						return NO;
					}
					else if( dataArray[i][column] != 0 )
					{
						break;
					}
				}
			}
		}
		
		//横
		for( row = 0; row < ROW_COUNT; ++ row )
		{
			for( column = 0; column < ROW_COUNT-1; ++ column )
			{
				for( int i = column + 1; i < COLUMN_COUNT; ++ i )
				{
					if( (dataArray[row][column] == dataArray[row][i] ) && (dataArray[row][column]!=0))
					{
						return NO;
					}
					else if( dataArray[row][i] != 0 )
					{
						break;
					}
				}
			}
		}
		
		return YES;
		
	}
	else
	{
		return NO;
	}
}


-(int)getBaseRandData
{
	//2 4 8 16  .....
    
    srand((unsigned)time(0));
    
    int ret = rand() % 3;
    
	return ret == 2? 4:2;
}


-(void)outPutData
{
    
    return;
    
    NSLog(@"输出变动数据");
    
    for(int row = 0; row < ROW_COUNT; ++ row )
    {
        for( int column = 0; column < COLUMN_COUNT; ++ column )
        {
            NSLog(@"%4d",dataArray[row][column]);
        }
        
        NSLog(@"\r\n");
    }
    
    NSLog(@"输出移动数据");
    
    for(int row = 0; row < ROW_COUNT; ++ row )
    {
        for( int column = 0; column < COLUMN_COUNT; ++ column )
        {
            NSLog(@"%4d",moveArray[row][column]);
        }
        
        NSLog(@"\r\n");
    }
}



-(void)increaseScore:(int)add
{
    score += add;
    
    NSString * str = [NSString stringWithFormat:@"%d",score];
    
    [self setValue:str forKey:@"score"];
}

//产生随机数
-(void)genRandData
{
    
    NSLog(@"----genRandData---");
    
	dispatch_async(dispatch_get_global_queue(0,0),^(void){
        
        int randRow = 0;
        int randColumn = 0;
		
		while(YES)
		{
            srand((unsigned)time(0));
            
            randRow =  rand()  % ROW_COUNT;
            randColumn = rand()  % COLUMN_COUNT;
            
			if( dataArray[randRow][randColumn] == 0 )
			{
                NSLog(@"generate data:%d---row:%d column:%d",[self getBaseRandData],randRow,randColumn);
                
                 dataArray[randRow][randColumn] = [self getBaseRandData];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    CGRect rect= CGRectMake(GRID_TIP_X + (GRID_TIP_X+PER_GRID_WIDTH)*randColumn, GRID_TIP_Y + (GRID_TIP_Y + PER_GRID_HEIGH) * randRow, PER_GRID_WIDTH, PER_GRID_HEIGH);
                    UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
                    imgView.layer.cornerRadius = 8;
                    imgView.layer.masksToBounds = YES;
                    imgView.tag = randRow * COLUMN_COUNT + randColumn + GRID_TAG_BASE;
                    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[randRow][randColumn],_skin]];
                    imgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                    [gridBgView addSubview:imgView];
                    
                    
                    [UIView animateWithDuration:0.05f animations:^(void){
                        imgView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                        
                    }completion:^(BOOL bFinished){
                        
                        [UIView animateWithDuration:0.15f animations:^(void){
                            
                            imgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        }completion:^(BOOL bFinished){
                            
                        }];
                    }];
                });
                
                //[self outPutData];

				return;
			}
            else
            {
                int i , j;
                
                for( i = randRow; i < ROW_COUNT * 2; ++ i )
                {
                    for( j = randColumn; j < COLUMN_COUNT * 2; ++ j )
                    {
                        if( dataArray[i%ROW_COUNT][j%COLUMN_COUNT] == 0 )
                        {
                            NSLog(@"=====generate data:%d---row:%d column:%d",[self getBaseRandData],i%ROW_COUNT,j%COLUMN_COUNT);
                            
                            dataArray[i%ROW_COUNT][j%COLUMN_COUNT] = [self getBaseRandData];
                            
                            randRow = i%ROW_COUNT;
                            randColumn = j%COLUMN_COUNT;
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                
                                CGRect rect= CGRectMake(GRID_TIP_X + (GRID_TIP_X+PER_GRID_WIDTH)*randColumn, GRID_TIP_Y + (GRID_TIP_Y + PER_GRID_WIDTH) * randRow, PER_GRID_WIDTH, PER_GRID_HEIGH);
                                UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
                                imgView.layer.cornerRadius = 8;
                                imgView.layer.masksToBounds = YES;
                                imgView.tag = randRow * COLUMN_COUNT + randColumn + GRID_TAG_BASE;
                                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[randRow][randColumn], _skin]];
                                
                                //NSLog(@"imgViewTag:%d",imgView.tag);
                                
                                [gridBgView addSubview:imgView];
                                
                            });
                            
                            //[self outPutData];
                            
                            return;
                        }
                    }
                }
            }
        }
	});

}


//move right

-(int)filterRight:(int [])data withStart:(int)start withLen:(int)len//filterRight(int data[] , int start,int len )
{
	int count = 0;
	for( int i = start; i >= 0; -- i )
	{
		if( data[i] == 0 )
		{
			count ++;
		}
		else
		{
			data[i+count] = data[i];
            
			if( count != 0 )
			{
				data[i] = 0;
			}
            
			break;
		}
	}
    
	return count;
}

-(void) moveRight
{
	int row , column;
    
	for( row = 0; row < ROW_COUNT; ++ row )
	{
		int right = 0;
        
		for( column = COLUMN_COUNT-1; column >= 0 ; -- column )
		{
			if( dataArray[row][column] == 0 )
			{
                right = [self filterRight:dataArray[row] withStart:column withLen:COLUMN_COUNT - column ];
				
				if( column + 1 != right )
				{
					moveArray[row][column-right] = right;
                    
                    NSLog(@"right:%d-%d-%d",row , column,moveArray[row][column-right]);
				}
				else
				{
					break;
				}
			}
            
			for( int cur = column - 1; cur >=0; -- cur )
			{
				if( dataArray[row][column] == dataArray[row][cur])
				{
					dataArray[row][column] *= 2;
					dataArray[row][cur] = 0;
                    
					moveArray[row][cur] = column-cur;
                    
                    delArray[row][cur] = YES;
                    spEffArray[row][column-right] = YES;
                    
                    //NSLog(@"sp right:%d-%d-%d-%d-%d-%d",column ,column-right,right,moveArray[row][cur],moveArray[row][column], cur);
                    
                    [self increaseScore:dataArray[row][column]];
                    
					break;
				}
				else if( dataArray[row][cur] != 0 )
				{
					break;
				}
			}
            
		}
	}
    
    
    return;
    
    ///
    NSLog(@"Move right log begin");
    
    for( int row = 0; row < ROW_COUNT; ++ row )
    {
        NSLog(@"data:%d-%d-%d-%d",dataArray[row][0],dataArray[row][1],dataArray[row][2],dataArray[row][3]);
    }
    
    for( int row = 0; row < ROW_COUNT; ++ row )
    {
        NSLog(@"move:%d-%d-%d-%d",moveArray[row][0],moveArray[row][1],moveArray[row][2],moveArray[row][3]);
    }

    
    for( int row = 0; row < ROW_COUNT; ++ row )
    {
        NSLog(@"spEff:%d-%d-%d-%d",spEffArray[row][0],spEffArray[row][1],spEffArray[row][2],spEffArray[row][3]);
    }
    
    for( int row = 0; row < ROW_COUNT; ++ row )
    {
        NSLog(@"Del:%d-%d-%d-%d",delArray[row][0],delArray[row][1],delArray[row][2],delArray[row][3]);
    }

    
    NSLog(@"Move right log end");
    
    
}


//move left
-(int)filterLeft:(int [])data withStart:(int)start withLen:(int)len
{
	int count = 0;
	for( int i = start; i < len+start; ++ i )
	{
		if( data[i] == 0 )
		{
			count ++;
		}
		else
		{
			data[i-count] = data[i];
            
			if( count != 0 )
			{
				data[i] = 0;
			}
            
			break;
		}
	}
    
	return count;
}


-(void) moveLeft
{
	int row , column;
    
	for( row = 0; row < ROW_COUNT; ++ row )
	{
		int left = 0;
        
		for( column = 0; column < COLUMN_COUNT; ++ column )
		{
			if( dataArray[row][column] == 0 )
			{
                left = [self filterLeft:dataArray[row] withStart:column withLen:(COLUMN_COUNT - column)];
                
				if( column + left < COLUMN_COUNT )
				{
					moveArray[row][column + left] = left;
				}
				else
				{
					break;
				}
			}
            
			for( int cur = column + 1; cur < COLUMN_COUNT; ++ cur )
			{
				if( dataArray[row][column] == dataArray[row][cur])
				{
					dataArray[row][column] *= 2;
					dataArray[row][cur] = 0;
                    
					moveArray[row][cur] = cur - column;
                    delArray[row][cur] = YES;
                    spEffArray[row][column+left] = YES;
                    
                    NSLog(@"sp left:%d-%d-%d-move:%d-%d",row,column+left,left,moveArray[row][cur],cur);
                    
                    [self increaseScore:dataArray[row][column]];
                    
                    
					break;
				}
				else if( dataArray[row][cur] != 0 )
				{
					break;
				}
			}
            
		}
	}
}



//move up
-(int) filterUp:(int [][COLUMN_COUNT])data withStartRow:(int)startRow withColumn:(int)column withRowLen:(int)rowLen
{
	int count = 0;
    
	for( int i = startRow; i < startRow + rowLen; ++ i )
	{
		if( data[i][column] == 0 )
		{
			count ++;
		}
		else
		{
			data[i-count][column] = data[i][column];
            
			if( count != 0 )
			{
				data[i][column] = 0;
			}
			break;
		}
	}
    
	return count;
}


//move donw

-(int)filterDown:(int [][COLUMN_COUNT])data withStartRow:(int)startRow withColumn:(int)column withLen:(int)len
{
	int count = 0;
    
	for( int i = startRow; i >= 0; -- i )
	{
		if( data[i][column] == 0 )
		{
			count ++;
		}
		else
		{
			data[i+count][column] = data[i][column];
            
			if( count != 0 )
			{
				data[i][column] = 0;
			}
            
			break;
		}
	}
    
	return count;
}



-(void) moveUp
{
	int row,column;
    
	for(column = 0; column < COLUMN_COUNT; ++ column )
	{
		for( row = 0; row < ROW_COUNT; ++ row)
		{
			int up = 0;
            
			if( dataArray[row][column] == 0 )
			{
               up = [self filterUp:dataArray withStartRow:row withColumn:column withRowLen:ROW_COUNT-row];
                
				if( row + up < ROW_COUNT )
				{
					moveArray[row + up][column] = up;
				}
				else
				{
					break;
				}
			}
            
			for( int cur = row + 1; cur < ROW_COUNT; ++ cur )
			{
				if( dataArray[row][column] == dataArray[cur][column])
				{
					dataArray[row][column] *= 2;
					dataArray[cur][column] = 0;
                    
					moveArray[cur][column] = cur - row;
                    
                    delArray[cur][column] = YES;
                    spEffArray[row+up][column] = YES;
                    
                    [self increaseScore:dataArray[row][column]];
                    
					break;
				}
				else if( dataArray[cur][column] != 0 )
				{
					break;
				}
			}
		}
	}
	
}

-(void) moveDown
{
	int row,column;
    
	for(column = 0; column < COLUMN_COUNT; ++ column )
	{
		for( row = ROW_COUNT-1; row >= 0; -- row)
		{
			int down = 0;
            
			if( dataArray[row][column] == 0 )
			{
                down = [self filterDown:dataArray withStartRow:row withColumn:column withLen:ROW_COUNT-row];
                
				if( row + 1 != down )
				{
					moveArray[row-down][column] = down;
				}
				else
				{
					break;
				}
			}
            
			for( int cur = row - 1; cur >= 0 ; -- cur )
			{
				if( dataArray[row][column] == dataArray[cur][column])
				{
					dataArray[row][column] *= 2;
					dataArray[cur][column] = 0;
                    
					moveArray[cur][column] = row-cur;
                    
                    delArray[cur][column] = YES;
                    spEffArray[row-down][column] = YES;
                    
                    [self increaseScore:dataArray[row][column]];
                    
					break;
				}
				else if( dataArray[cur][column] != 0 )
				{
					break;
				}
			}
		}
	}
}


-(BOOL)canMove2
{
    int row,column;
    
    for( row = 0; row < ROW_COUNT; ++ row )
    {
        for( column = 0; column < COLUMN_COUNT; ++ column )
        {
            if( moveArray[row][column] != 0 )
            {
                return YES;
            }
        }
    }
    
    return NO;
}

//判断是否可以往某个方向移动
-(BOOL)canMoveDir1:(MOVE_DIR)dir
{
    int row,column;
    
    if( MOVE_DIR_LEFT == dir )
    {
        for(row = 0; row < ROW_COUNT; ++ row )
        {
            int zeroCount = 0;
            
            for( column = 0; column < COLUMN_COUNT; ++ column )
            {
                if( dataArray[row][column] == 0 )
                {
                    zeroCount++;
                }
                else
                {
                    if( zeroCount > 0 )
                    {
                        return  YES;
                    }
                }
            }
            
            if( zeroCount == COLUMN_COUNT)
            {
                //return YES;
            }
        }

    }
    else if( MOVE_DIR_RIGHT == dir )
    {
        for(row = 0; row < ROW_COUNT; ++ row )
        {
            int zeroCount = 0;
            
            for( column = COLUMN_COUNT-1; column >= 0; -- column )
            {
                if( dataArray[row][column] == 0 )
                {
                    zeroCount ++;
                }
                else
                {
                    if( zeroCount > 0)
                    {
                        return YES;
                    }
                }
            }
            
            if( zeroCount == COLUMN_COUNT)
            {
                //return YES;
            }
        }

    }
    else if( MOVE_DIR_UP == dir )
    {
        for(column = 0; column < ROW_COUNT; ++ column )
        {
            int zeroCount = 0;
            
            for( row = 0; row < COLUMN_COUNT; ++ row )
            {
                if( dataArray[row][column] == 0 )
                {
                    zeroCount++;
                }
                else
                {
                    if( zeroCount>0 )
                    {
                        return YES;
                    }
                }
            }
            
            if( zeroCount == ROW_COUNT)
            {
                //return YES;
            }
        }

    }
    else if( MOVE_DIR_DOWN == dir )
    {
        for(column = 0; column < ROW_COUNT; ++ column )
        {
            int zeroCount = 0;
            
            for( row = COLUMN_COUNT - 1; row >= 0; -- row )
            {
                if( dataArray[row][column] == 0 )
                {
                    zeroCount++;
                }
                else
                {
                    if( zeroCount>0 )
                    {
                        return YES;
                    }
                }
            }
            
            if( zeroCount == ROW_COUNT)
            {
                //return YES;
            }
        }

    }
    
    return NO;
}
    
//移动
-(void)move:(MOVE_DIR)dir
{
    touchDown = NO;
    
    [self revertData];
    
    BOOL bMove = [self canMoveDir1:dir];
    
    //[self outPutData];
    
    NSLog(@"bMove:%d",bMove);
    
    
    if( MOVE_DIR_LEFT == dir )
    {
        [self moveLeft];
    }
    else if( MOVE_DIR_RIGHT == dir )
    {
        [self moveRight];
    }
    else if( MOVE_DIR_UP == dir )
    {
        [self moveUp];
    }
    else if( MOVE_DIR_DOWN == dir )
    {
        [self moveDown];
    }
    
    //[self outPutData];
    
    
    if( bMove || [self canMove2] )
    {
        [self drawGameAnimation:dir];
    }

}


-(void)outPutGridViewTag
{
    for( UIView * view in [gridBgView subviews] )
    {
       // NSLog(@"viewTag:%d",view.tag);
    }
}


-(void)refreshGameSkin
{
    _skin = [appDel getSkin];
    
    
    for(UIImageView * imgView in [gridBgView subviews] )
    {
        [imgView removeFromSuperview];
    }
    
    [self drawGame];
    
}


-(void)drawGameAnimation:(MOVE_DIR)dir
{
    
    int row,column;
    
    [self outPutGridViewTag];
    
    if( MOVE_DIR_LEFT == dir )
    {
        for( row = 0; row < ROW_COUNT; ++ row )
        {
            for( column = 0; column < COLUMN_COUNT; ++ column )
            {
                //if( moveArray[row][column] != 0 )
                {
                    UIImageView * imgView = (UIImageView*)[gridBgView viewWithTag:(row * COLUMN_COUNT + column + GRID_TAG_BASE)];

                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        [UIView animateWithDuration:0.08f animations:^(void){
                        
                            CGPoint pt = imgView.center;
                            pt = CGPointMake(pt.x - (PER_GRID_WIDTH + GRID_TIP_X) * moveArray[row][column], pt.y);
                            imgView.center = pt;
                            
                         }completion:^(BOOL bFinished){
                            
                            if( delArray[row][column])
                            {
                                NSLog(@"delImg:row=%d column=%d",row,column);
                                
                                [imgView removeFromSuperview];
                            }
                            else
                            {
                                imgView.tag = row * COLUMN_COUNT + column - moveArray[row][column]+GRID_TAG_BASE;
                                
                                if( spEffArray[row][column] )
                                {
                                    NSLog(@"spEff row:%d column:%d",row,column);
                                    
                                    [UIView animateWithDuration:0.05f animations:^(void){
                                        
                                        imgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                                        
                                    }completion:^(BOOL bFinished){
                                        
                                        [UIView animateWithDuration:0.05f animations:^(void){
                                            
                                            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[row][column- moveArray[row][column]],_skin]];
                                            
                                            imgView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                                            
                                        }completion:^(BOOL bFinished){
                                            
                                            [UIView animateWithDuration:0.05f animations:^(void){
                                                
                                                imgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                
                                            }completion:^(BOOL bFinished){
                                                
                                            }];
                                            
                                        }];
                                        
                                    }];
                                }

                            }
                            
                       }];
                        
                    });
               }
            }
        }
        
    }
    else if( MOVE_DIR_RIGHT == dir )
    {
        for( row = 0; row < ROW_COUNT; ++ row )
        {
            for( column = COLUMN_COUNT-1; column >=0; -- column )
            {
                //if( moveArray[row][column] != 0 )
                {
                    UIImageView * imgView = (UIImageView*)[gridBgView viewWithTag:(row * COLUMN_COUNT + column + GRID_TAG_BASE)];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        [UIView animateWithDuration:0.08f animations:^(void){
                            
                            CGPoint pt = imgView.center;
                            pt = CGPointMake(pt.x + (PER_GRID_WIDTH + GRID_TIP_X) * moveArray[row][column], pt.y);
                            imgView.center = pt;
                            
                           
                            
                        }completion:^(BOOL bFinished){
                            
                            if( delArray[row][column])
                            {
                                NSLog(@"delImg:row=%d column=%d",row,column);
                                
                                [imgView removeFromSuperview];
                            }
                            else
                            {
                                imgView.tag = row * COLUMN_COUNT + column + moveArray[row][column]+GRID_TAG_BASE;
                                
                                if( spEffArray[row][column] )
                                {
                                    NSLog(@"spEff row:%d column:%d",row,column);
                                    
                                    [UIView animateWithDuration:0.05f animations:^(void){
                                        
                                        imgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                                        
                                    }completion:^(BOOL bFinished){
                                        
                                        [UIView animateWithDuration:0.05f animations:^(void){
                                            
                                            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[row][column+ moveArray[row][column]],_skin]];
                                          
                                            imgView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                                            
                                        }completion:^(BOOL bFinished){
                                            
                                            [UIView animateWithDuration:0.05f animations:^(void){
                                                
                                                imgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                
                                            }completion:^(BOOL bFinished){
                                                
                                            }];
                                            
                                        }];
                                        
                                    }];
                                }
                            }
                            
                         }];
                    });

                }
            
            }
        }

    }
    else if( MOVE_DIR_UP == dir )
    {
        for( column = 0; column < COLUMN_COUNT; ++ column )
        {
            for( row = 0; row < ROW_COUNT; ++ row )
            {
                //if( moveArray[row][column] != 0 )
                {
                    UIImageView * imgView = (UIImageView*)[gridBgView viewWithTag:(row * COLUMN_COUNT + column + GRID_TAG_BASE)];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        [UIView animateWithDuration:0.08f animations:^(void){
                            
                            CGPoint pt = imgView.center;
                            pt = CGPointMake(pt.x ,pt.y - (PER_GRID_HEIGH + GRID_TIP_Y) * moveArray[row][column]);
                            imgView.center = pt;
                            
                        }completion:^(BOOL bFinished){
                            
                            if( delArray[row][column])
                            {
                                NSLog(@"delImg:row=%d column=%d",row,column);
                                
                                [imgView removeFromSuperview];
                            }
                            else
                            {
                                imgView.tag = row * COLUMN_COUNT + column - moveArray[row][column]*COLUMN_COUNT+GRID_TAG_BASE;
                                
                                if( spEffArray[row][column] )
                                {
                                    NSLog(@"spEff row:%d column:%d",row,column);
                                    
                                    [UIView animateWithDuration:0.05f animations:^(void){
                                        
                                        imgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                                        
                                    }completion:^(BOOL bFinished){
                                        
                                        [UIView animateWithDuration:0.05f animations:^(void){
                                            
                                            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[row-moveArray[row][column]][column],_skin]];
                                            
                                            imgView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                                            
                                        }completion:^(BOOL bFinished){
                                            
                                            [UIView animateWithDuration:0.05f animations:^(void){
                                                
                                                imgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                
                                            }completion:^(BOOL bFinished){
                                                
                                            }];
                                            
                                        }];
                                        
                                    }];
                                }
                            }
                        }];
                    });
                 }
            }
        }
    }
    else if( MOVE_DIR_DOWN == dir )
    {
        for( column = 0; column < COLUMN_COUNT; ++ column )
        {
            for( row = ROW_COUNT-1; row >= 0; -- row )
            {
                //if( moveArray[row][column] != 0 )
                {
                    UIImageView * imgView = (UIImageView*)[gridBgView viewWithTag:(row * COLUMN_COUNT + column + GRID_TAG_BASE)];
 
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        [UIView animateWithDuration:0.08f animations:^(void){
                            
                            CGPoint pt = imgView.center;
                            pt = CGPointMake(pt.x ,pt.y + (PER_GRID_HEIGH + GRID_TIP_Y) * moveArray[row][column]);
                            imgView.center = pt;
                            
                            
                        }completion:^(BOOL bFinished){
                            
                            if( delArray[row][column])
                            {
                                NSLog(@"delImg:row=%d column=%d",row,column);
                                
                                [imgView removeFromSuperview];
                            }
                            else
                            {
                                imgView.tag = row * COLUMN_COUNT + column + moveArray[row][column]*COLUMN_COUNT+GRID_TAG_BASE;
                                
                                if( spEffArray[row][column] )
                                {
                                    NSLog(@"spEff row:%d column:%d",row,column);
                                    
                                    [UIView animateWithDuration:0.05f animations:^(void){
                                        
                                        imgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                                        
                                    }completion:^(BOOL bFinished){
                                        
                                        [UIView animateWithDuration:0.05f animations:^(void){
 
                                            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[row+moveArray[row][column]][column],_skin]];

                                            
                                            imgView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
                                            
                                        }completion:^(BOOL bFinished){
                                            
                                            [UIView animateWithDuration:0.05f animations:^(void){
                                                
                                                imgView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                
                                            }completion:^(BOOL bFinished){
                                                
                                            }];
                                            
                                        }];
                                        
                                    }];
                                }
                            }
                        }];
                    });
                 }
            }
        }
    }
    
    [self performSelector:@selector(genRandData) withObject:self afterDelay:0.2f];
}


-(void)drawGame
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        int row,column;
        
        for( row = 0; row < ROW_COUNT; ++ row )
        {
            for( column = 0; column < COLUMN_COUNT; ++ column )
            {
                if( dataArray[row][column] != 0 )
                {
                    CGRect rect =CGRectMake(GRID_TIP_X + (PER_GRID_WIDTH + GRID_TIP_X) * column,GRID_TIP_Y + (PER_GRID_HEIGH + GRID_TIP_Y) * row , PER_GRID_WIDTH , PER_GRID_HEIGH);
                    
                    UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
                    imgView.tag = row * COLUMN_COUNT + column+GRID_TAG_BASE;
                    imgView.layer.cornerRadius = 8;
                    imgView.layer.masksToBounds = YES;
                    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_%d",dataArray[row][column],_skin]];
                    
                    [gridBgView addSubview:imgView];
                    
                    NSLog(@"add data  row:%d column:%d tag:%d",row,column,imgView.tag);
                }
            }
        }
    });
    
}


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch * touch = [touches anyObject];
	CGPoint currPT = [touch locationInView:self];
	moveFromPT = currPT;
    
    touchDown  = YES;
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch * touch = [touches anyObject];
	CGPoint currPT = [touch locationInView:self];
    
    if( !touchDown )
    {
        return;
    }
    
   
	
	if( fabs(moveFromPT.x-currPT.x) >= SMALLEXT_MOVE_DIS )
	{
		if( moveFromPT.x > currPT.x )
		{
			NSLog(@"move left");
            
            [self move:MOVE_DIR_LEFT];
		}
		else
		{
			
            [self move:MOVE_DIR_RIGHT];
		}
	}
	else if( fabs(moveFromPT.y-currPT.y) >= SMALLEXT_MOVE_DIS )
	{
		if( moveFromPT.y > currPT.y )
		{
			
            [self move:MOVE_DIR_UP];
		}
		else
		{
			
            [self move:MOVE_DIR_DOWN];
		}
	}
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
