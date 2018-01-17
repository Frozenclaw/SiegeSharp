local oldfunc = ConstructMixin.OnConstructUpdate

if server then

function ConstructMixin:OnConstructUpdate(deltaTime)
        
    local effectTimeout = Shared.GetTime() - self.timeLastConstruct > 0.65
    self.underConstruction = not self:GetIsBuilt() and not effectTimeout
	
    -- Only Alien structures auto build.
    -- Update build fraction every tick to be smooth.
    if not self:GetIsBuilt() and GetIsAlienUnit(self) and GetIsMarineUnit(self) then
	
	for index, constructable in ipairs(GetEntitiesWithMixin("Construct")) do
        
		if not constructable:GetIsBuilt() then
			constructable:SetConstructionComplete()
		end
            
		end
		
        if not self.GetCanAutoBuild or self:GetCanAutoBuild() then
        
            local multiplier = self.hasDrifterEnzyme and kDrifterBuildRate or kAutoBuildRate
            multiplier = multiplier * ( (HasMixin(self, "Catalyst") and self:GetIsCatalysted()) and kNutrientMistAutobuildMultiplier or 1 )
            self:Construct(deltaTime * multiplier)
			
		
        end
		
    end  
    
end

end -- end server 
