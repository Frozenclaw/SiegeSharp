local oldfunc = ConstructMixin.OnConstructUpdate

if server then

function ConstructMixin:OnConstructUpdate(deltaTime)
        
    local effectTimeout = Shared.GetTime() - self.timeLastConstruct > 0.65
    self.underConstruction = not self:GetIsBuilt() and not effectTimeout
    
    -- Only Alien structures auto build.
    -- Update build fraction every tick to be smooth.
    if not self:GetIsBuilt() and GetIsAlienUnit(self) and GetIsMarineUnit(self) then

        if not self.GetCanAutoBuild or self:GetCanAutoBuild() then
        
            local multiplier = self.hasDrifterEnzyme and kDrifterBuildRate or kAutoBuildRate
            multiplier = multiplier * ( (HasMixin(self, "Catalyst") and self:GetIsCatalysted()) and kNutrientMistAutobuildMultiplier or 1 )
            self:Construct(deltaTime * multiplier)
			
			local frontmultiplier = self.buildtime 
			frontdoormultiplier = frontmultiplier * ( (HasMixin(self, "PowerConsumer") ) or 1)
			self:Construct(deltaTime * frontmultiplier)
            
        end
		
	
		
    end
    
    
end


end