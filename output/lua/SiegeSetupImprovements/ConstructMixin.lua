local oldfunc = ConstructMixin.OnConstructUpdate

if Server then
  
function ConstructMixin:OnConstructUpdate(deltaTime)
        
    local effectTimeout = Shared.GetTime() - self.timeLastConstruct > 0.65
    self.underConstruction = not self:GetIsBuilt() and not effectTimeout
    
    -- Only Alien structures auto build.
    -- Update build fraction every tick to be smooth.
    if not self:GetIsBuilt() and GetIsAlienUnit(self) then

        if not self.GetCanAutoBuild or self:GetCanAutoBuild() then
        
            local multiplier = self.hasDrifterEnzyme and kDrifterBuildRate or kAutoBuildRate
            multiplier = multiplier * ( (HasMixin(self, "Catalyst") and self:GetIsCatalysted()) and kNutrientMistAutobuildMultiplier or 1 )
            self:Construct(deltaTime * multiplier)
            
        end
    
    end
	
	if not self:GetIsBuilt() and GetIsMarineUnit(self) and self.GetIsPowered and GetGamerules():GetFrontDoorsOpen() == false and self:GetIsPowered() == true then
		self:SetConstructionComplete()
	
	end 
    
    if self.timeDrifterConstructEnds then
        
        if self.timeDrifterConstructEnds <= Shared.GetTime() then
        
            self.hasDrifterEnzyme = false
            self.timeDrifterConstructEnds = nil
            
        end
        
    end

    -- respect the cheat here; sometimes the cheat breaks due to things relying on it NOT being built until after a frame
    if GetGamerules():GetAutobuild() then
        self:SetConstructionComplete()
	

    end
    
    if self.underConstruction or not self.constructionComplete then
        return kUpdateIntervalFull
    end
    
    -- stop running once we are fully constructed
    return false
    
end

end -- Server
