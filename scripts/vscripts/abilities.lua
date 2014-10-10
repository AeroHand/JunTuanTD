
--邪恶狂热
function XieEKuangReCreate( keys )
	local caster = keys.caster

	--用于判断CD过程中复活
	if caster:HasModifier("modifier_xie_e_kuang_re") and keys.ability:IsCooldownReady()==false then
		caster:RemoveModifierByName("modifier_xie_e_kuang_re")
		return
	end

	if caster:HasModifier("modifier_xie_e_kuang_re") then
		--获取技能等级
		local lvl = keys.ability:GetLevel() - 1

		--获取技能CD
		local cd = keys.ability:GetCooldown(lvl)

		--启动技能CD
		keys.ability:StartCooldown(cd)

		caster:RemoveModifierByName("modifier_xie_e_kuang_re")

		--添加modifier
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_xie_e_kuang_re_buff", nil)

		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("XieEKuangReCreate"), 
			function( )
				if caster:IsAlive() then
					keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_xie_e_kuang_re", nil)
				end
				return nil
			end, cd+0.05)
	end
end


--狂战士
function KuangZhanShiHeal( keys )
	local caster = keys.caster

	--获取叠加的次数
	local count = caster:GetContext("KuangZhanShiHeal") or 0

	--获取技能等级，并且获取buff最高叠加次数
	local lvl = keys.ability:GetLevel() - 1
	local buff_max = keys.ability:GetLevelSpecialValueFor("buff_max", lvl)
	local heal_percent = keys.ability:GetLevelSpecialValueFor("heal", lvl)

	--获取生命值百分比
	local caster_heal_percent = caster:GetHealth()/caster:GetMaxHealth() * 100

	--获取已损失生命值百分比
	local lose_heal_percent = 100 - caster_heal_percent

	--获取百分比个位之前的数值
	local num = lose_heal_percent - (heal_percent * count)

	if num>heal_percent and count<buff_max then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_kuang_zhan_shi_attack_speed", nil)

		count = count + 1
		caster:SetContextNum("KuangZhanShiHeal", count, 0)

		return
	end

	for k=1,count do
		local x = lose_heal_percent - (heal_percent * count)
		if x<0 then
			caster:RemoveModifierByName("modifier_kuang_zhan_shi_attack_speed")
		
			count = count - 1
			caster:SetContextNum("KuangZhanShiHeal", count, 0)
		
		else
			break
		end
	end
		
end


--浸毒武器
function JinDuWuQi( keys )
	local target = keys.target

	local i = keys.ability:GetLevel() - 1

	--获取记录的叠加伤害
	local x = target:GetContext("JinDuWuQi") or 0

	local damage = keys.ability:GetLevelSpecialValueFor("damage", i)

	target:SetContextNum("JinDuWuQi", x+damage, 0)
end

function JinDuWuQiDamage( keys )
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	--获取叠加的伤害
	local damage = target:GetContext("JinDuWuQi")

	local damageTable = {victim=target,
						attacker=caster,
						damage_type=DAMAGE_TYPE_MAGICAL,
						damage=damage}
	ApplyDamage(damageTable)
end

function JinDuWuQiDestroy( keys )
	--清零
	keys.target:SetContextNum("JinDuWuQi", 0, 0)
end


--风暴之锤
function FengBaoZhiChui( keys )
	local caster = keys.caster
	local target = keys.target

	if caster:HasModifier("modifier_feng_bao_zhi_chui") and keys.ability:IsCooldownReady()==false then
		caster:RemoveModifierByName("modifier_feng_bao_zhi_chui")
		return
	end

	if caster:HasModifier("modifier_feng_bao_zhi_chui") and keys.ability:IsCooldownReady() then
		caster:RemoveModifierByName("modifier_feng_bao_zhi_chui")

		local i = keys.ability:GetLevel() - 1

		local cd = keys.ability:GetCooldown(i)

		keys.ability:StartCooldown(cd)

		local info = 
	    {
	        Target = target,
	        Source = caster,
	        Ability = keys.ability,  
	        EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
	        bDodgeable = false,
	        iMoveSpeed = 1100,
	        bProvidesVision = true,
	        iVisionRadius = 300,
	        iVisionTeamNumber = caster:GetTeamNumber(),
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	    }
	    projectile = ProjectileManager:CreateTrackingProjectile(info)

	    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("FengBaoZhiChui"), 
	    	function( )
	    		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_feng_bao_zhi_chui", nil)
	    	end, cd+0.05)
	end
end


--召唤单位
function XXX( keys )
	local caster = keys.caster

	if caster:HasModifier("modifier_xxx") and keys.ability:IsCooldownReady()==false then
		caster:RemoveModifierByName("modifier_xxx")
		return
	end

	if caster:HasModifier("modifier_xxx") and keys.ability:IsCooldownReady() then
		caster:RemoveModifierByName("modifier_xxx")

		local i = keys.ability:GetLevel() - 1

		local cd = keys.ability:GetCooldown(i)

		keys.ability:StartCooldown(cd)

		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_xxx_create_unit", nil)

	    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("XXX"), 
	    	function( )
	    		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_xxx", nil)
	    	end, cd+0.05)
	end
end


--闪电
function ShanDian( keys )
	local caster = keys.caster

	local lvl = keys.ability:GetLevel() - 1

	--获取攻击次数
	local attack_num = keys.ability:GetLevelSpecialValueFor("attack_num", lvl)

	--获取记录的攻击次数
	local count = caster:GetContext("ShanDian") or 0

	if count<attack_num-1 then
		count = count + 1
		caster:SetContextNum("ShanDian", count, 0)
	else
		caster:SetContextNum("ShanDian", 0, 0)

		local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local types = DOTA_UNIT_TARGET_ALL
	    local flags = DOTA_UNIT_TARGET_FLAG_NONE

		--获取检测范围
		local radius = keys.ability:GetLevelSpecialValueFor("radius", lvl)

		local group = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, teams, types, flags, FIND_UNITS_EVERYWHERE, true) 
		
		local info = 
	    {
	        Target = group[1],
	        Source = caster,
	        Ability = keys.ability,  
	        EffectName = "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
	        bDodgeable = false,
	        iMoveSpeed = 1100,
	        bProvidesVision = true,
	        iVisionRadius = 300,
	        iVisionTeamNumber = caster:GetTeamNumber(),
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	    }
	    projectile = ProjectileManager:CreateTrackingProjectile(info)

	    caster:SetModifierStackCount("modifier_shan_dian",caster,0)
	end

	caster:SetModifierStackCount("modifier_shan_dian",caster,count)
end