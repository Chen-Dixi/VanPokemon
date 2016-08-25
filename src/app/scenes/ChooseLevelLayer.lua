
local ChooseLevelLayer = class("ChooseLevelLayer", function()
    return display.newLayer()--layer默认高宽是全屏幕
end)

local currentLevelBtnScale = 1.5
local behindLevelBtnScale = 0.7

function ChooseLevelLayer:ctor()

	self:setTouchEnabled(true)
    --关卡名字数组 
    self.levelName={"第一关","第二关","第三关"}
    --名字索引
    self.nameIndex=2
    self.isCanTouch = true  -- 防止在动画播放过程中 ，进行游戏操作
    self.levelSprites={}--关卡按钮的一位数组，
    --[[
    local level1=display.newSprite("image/第一关.png")
        :pos(display.left+100, display.cy)
        :size(10, 10)
        :scale(0.1)
    self:addChild(level1)

    local level2=display.newSprite("image/第二关.png")
        :pos(display.cx, display.cy)
        :size(10, 10)
        :scale(0.2)
        :addTo(self)
    self:addChild(level2)
    local level3=display.newSprite("image/第三关.png")
        :pos(display.right-100, display.cy)
        :size(10, 10)
        :scale(0.1)
    self:addChild(level3)

    self.levelSprite={level1,level2.level3}]]
    local level1 = cc.ui.UIPushButton.new("image/第一关.png",{name="第一关"})
    level1:onButtonClicked(function(event)
        end):setButtonSize(150,160)
            :pos(display.left+100, display.cy)
            :scale(behindLevelBtnScale)
            --:setAnchorPoint(0,0)--设置锚点
            :addTo(self)

    local level2 = cc.ui.UIPushButton.new("image/第二关.png",{name="第二关"})
    level2:onButtonClicked(function(event)
        end):setButtonSize(150,160)
            :pos(display.cx, display.cy-50)
            :scale(1.5)
            --:setAnchorPoint(0,0)--设置锚点
            :addTo(self)

    local level3 = cc.ui.UIPushButton.new("image/第三关.png",{name="第三关"})
    level3:onButtonClicked(function(event)
            
            
        end):setButtonSize(150,160)
            :pos(display.right-100, display.cy)
            :scale(behindLevelBtnScale)
            --:setAnchorPoint(0,0)--设置锚点
            :addTo(self)
    self.levelSprites={level1,level2,level3}

    self.xStart = nil--手势起始位置
    self.xEnd = nil

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name == "began" then
            if self.isCanTouch == false then
                print("isCanTouch = false")
                return false 
            end 
    		self.xStart=event.x
    		return true
    	elseif event.name=="ended" then
            print("name = ended")
    		if self.xStart == nil then return end --如果手势开始位置是nil
    		self.xEnd=event.x
    		if self.xEnd ~= nil and (self.xStart-display.cx)*(self.xEnd - display.cx) < 0 then--在cx两边
    			print("调用滑动")
                self.isCanTouch = false
                self:swipeLevelView(self.xEnd-self.xStart)--调用滑动
    		end
            --清空xStart .End记录
            self.xStart=nil
            self.xEnd=nil
    	end
    end)

    self.levelLabel = cc.ui.UILabel.new({
            --UILabelType = cc.ui.UILabel.LABEL_TYPE_TTF,
            text = "第二关",
            size = 40,
            color = display.COLOR_WHITE
        })
        --:ignoreAnchorPointForPosition(false)
        :setAnchorPoint(0.5,0.5)
        :pos(display.cx,display.cy-200)
        :addTo(self)
    
end

function ChooseLevelLayer:swipeLevelView(direction)
	--首先获取 三个关卡的 精灵
	local prevLevel, currLevel, nextLevel=self.levelSprites[1], self.levelSprites[2], self.levelSprites[3]
	--然后重新交换数字的位置
    if direction > 0 then --direction > 0 表示从左滑到右

        print("do swipe")
        --交换数组内顺序
	   self.levelSprites[1], self.levelSprites[2], self.levelSprites[3] = self.levelSprites[3], self.levelSprites[1], self.levelSprites[2]
        local spawnPrev = cc.Sequence:create( cc.Spawn:create(cc.ScaleTo:create(0.5,1.5),cc.BezierTo:create(0.5,{cc.p(display.left+100, display.cy-50),cc.p(display.left+100, display.cy-50),cc.p(display.cx, display.cy-50)})),cc.CallFunc:create(function() 
                                                             self.isCanTouch=true
                                                          end
                                                          ))
        prevLevel:runAction(spawnPrev)

        local spawnCurr = cc.Spawn:create(cc.ScaleTo:create(0.5,behindLevelBtnScale),cc.BezierTo:create(0.5,{cc.p(display.right-100, display.cy-50),cc.p(display.right-100, display.cy-50),cc.p(display.right-100, display.cy)}))
        currLevel:runAction(spawnCurr)

        local spawnNext = cc.Spawn:create(cc.ScaleTo:create(0.5,behindLevelBtnScale),cc.MoveTo:create(0.5,cc.p(display.left+100, display.cy)))
        nextLevel:runAction(spawnNext)
        if self.nameIndex==1 then self.nameIndex=3
        else
            self.nameIndex=self.nameIndex-1
        end
        
        self.levelLabel:setString(self.levelName[self.nameIndex])

    elseif direction < 0 then
        self.levelSprites[1], self.levelSprites[2], self.levelSprites[3] = self.levelSprites[2], self.levelSprites[3], self.levelSprites[1]
        local spawnPrev = cc.Sequence:create(cc.Spawn:create(cc.ScaleTo:create(0.5,behindLevelBtnScale),cc.MoveTo:create(0.5,cc.p(display.right-100, display.cy))),cc.CallFunc:create(function() 
                                                             self.isCanTouch=true
                                                          end
                                                          ))
        prevLevel:runAction(spawnPrev)

        local spawnCurr = cc.Spawn:create(cc.ScaleTo:create(0.5,behindLevelBtnScale),cc.BezierTo:create(0.5,{cc.p(display.left+100, display.cy-50),cc.p(display.left+100, display.cy-50),cc.p(display.left+100, display.cy)}))
        currLevel:runAction(spawnCurr)

        local spawnNext = cc.Spawn:create(cc.ScaleTo:create(0.5,1.5),cc.BezierTo:create(0.5,{cc.p(display.right-100, display.cy-50),cc.p(display.right-100, display.cy-50),cc.p(display.cx, display.cy-50)}))
        nextLevel:runAction(spawnNext)

        if self.nameIndex==3 then self.nameIndex=1
        else
            self.nameIndex=self.nameIndex+1
        end
        
        self.levelLabel:setString(self.levelName[self.nameIndex])
    end
    
	--print(self.levelSprite[1], self.levelSprite[2], self.levelSprite[3])
end

return ChooseLevelLayer