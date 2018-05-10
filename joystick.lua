--REFERENCE: https://forums.coronalabs.com/topic/32941-virtual-joystick-module-for-games/

J = {}

function joystick(group, imgJoystick, joyWidth, joyHeight, imgBgJoystick, bgWidth, bgHeight, distScale)
    local stage = display.getCurrentStage();
    local mMin = math.min;
    local mCos = math.cos;
    local mSin = math.sin;
    local mAtan2 = math.atan2;
    local mSqrt = math.sqrt;
    local mFloor = math.floor;
    local mPi = math.pi;

    local joyGroup = display.newGroup();
    group:insert(joyGroup);
    local bgJoystick = display.newImageRect(joyGroup, imgBgJoystick, bgWidth, bgHeight );
    bgJoystick.x, bgJoystick.y = 0, 0;
    local radius = bgJoystick.contentWidth/4;
    joyGroup.radius = radius;
    local radToDeg = 180/mPi;
    local degToRad = mPi/180;
    local joystick = display.newImageRect(joyGroup, imgJoystick, joyWidth, joyHeight );

    function joystick:touch(event)
        local phase = event.phase;
        if phase == "moved" then
            if self.isFocus then
                local parent = self.parent;
                local posX, posY = parent:contentToLocal(event.x, event.y);
                local angle = (mAtan2( posX, posY )*radToDeg)-90;
                if angle < 0 then angle = 360 + angle end;
                local distance = mSqrt((posX*posX)+(posY*posY));
                if distance >= radius*distScale then
                    local radAngle = angle*degToRad;
                    distance = radius*distScale;
                    self.x, self.y = distance*mCos(radAngle), -distance*mSin(radAngle)
                else
                    self.x, self.y = posX, posY;
                end
                if distance > 1 then parent.angle = angle end;
                parent.distance = distance;
                parent.xLoc, parent.yLoc = self.x, self.y;
            else
                stage:setFocus(event.target, event.id);
                self.isFocus = true;
                self.parent.state = true;
                self.parent.xLoc, self.parent.yLoc = 0, 0;
            end
        elseif phase == "began" then
            stage:setFocus(event.target, event.id);
            self.isFocus = true;
            self.parent.state = true;
            local parent = self.parent;
            local posX, posY = parent:contentToLocal(event.x, event.y);
            self.x, self.y = posX, posY;
            local angle = (mAtan2( posX, posY )*radToDeg)-90;
            if angle < 0 then angle = 360 + angle end;
            local distance = mSqrt((posX*posX)+(posY*posY));
            if distance >= radius*distScale then
                local radAngle = angle*degToRad;
                distance = radius*distScale;
                self.x, self.y = distance*mCos(radAngle), -distance*mSin(radAngle)
            else
                self.x, self.y = posX, posY;
            end
            if distance > 1 then parent.angle = angle end;
            parent.distance = distance;
            parent.xLoc, parent.yLoc = self.x, self.y;
        else
            self.isFocus = false;
            self.parent.state = false;
            self.x, self.y = 0, 0;
            self.parent.distance = 0;
            stage:setFocus(nil, event.id);
            self.parent.xLoc, self.parent.yLoc = 0, 0;
        end
        return true;
    end

    joyGroup.activate = function()
        joyGroup[1]:addEventListener("touch", joyGroup[2]);
        joyGroup.angle, joyGroup.distance = 0, 0;
        joyGroup.xLoc, joyGroup.yLoc = 0, 0;
    end
    joyGroup.deactivate = function()
        joyGroup[1]:removeEventListener("touch", joyGroup[2]);
        joyGroup.angle, joyGroup.distance = 0, 0;
        joyGroup.xLoc, joyGroup.yLoc = 0, 0;
    end
    joyGroup.x, joyGroup.y = joyGroup.contentWidth*0.5, display.contentHeight-joyGroup.contentHeight*0.5;
    return (joyGroup);
end

J.joystick = joystick

return J
