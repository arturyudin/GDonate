gpay.saver = gpay.saver or {}

function gpay.saver.GettingSettings(ply,dat)
    if ply:IsValid() and dat and dat.age == "save" then

        ply.donate_weapons = dat.weapons

        ply.boosters = dat.boosters

        if gpay.GetItem(dat.hat) and ply:HasItem(dat.hat) then

            ply:SetDonateHat(dat.hat)
            gpay.Notify(ply,false,color_white,"Вы надели шапку "..gpay.GetItem(dat.hat).name)

        else

            ply:SetDonateHat("")
            gpay.Notify(ply,false,color_white,"Вы сняли шапку")

        end

    elseif ply:IsValid() and dat and dat.age == "give" then

        if dat.type == "boost" and not ply.activeboosters[dat.class] and ply:HasItem(dat.class) then
            ply.activeboosters[dat.class] = true
            gpay.boosters[dat.class](ply)
            gpay.NotifySound(ply,"garrysmod/save_load4.wav")
            gpay.Notify(ply,false,color_white,"Вы активировали "..gpay.GetItem(dat.class).name)
        elseif dat.type == "weapon" and not ply:HasWeapon(dat.class) and ply:HasItem(dat.class) then
            ply:Give(dat.class)
            gpay.NotifySound(ply,"garrysmod/save_load4.wav")
            gpay.Notify(ply,false,color_white,"Вы взяли "..gpay.GetItem(dat.class).name)
        elseif ply:HasItem(dat.class) then
            gpay.Notify(ply,true,Color(255,255,255),"У вас уже есть данный предмет!")
        end
    elseif ply:IsValid() and dat and dat.age == "givef" then

        if dat.type == "boost" and not ply.activeboosters[dat.class] and ply:HasItem(dat.class) then
            ply.activeboosters[dat.class] = true
            gpay.boosters[dat.class](ply)
            --gpay.NotifySound(ply,"garrysmod/save_load4.wav")
        elseif dat.type == "weapon" and not ply:HasWeapon(dat.class) and ply:HasItem(dat.class) then
            ply:Give(dat.class)
            --gpay.NotifySound(ply,"garrysmod/save_load4.wav")
        elseif ply:HasItem(dat.class) then
            --print(dat.class)
           -- gpay.Notify(ply,true,Color(255,255,255),"У вас уже есть данный предмет!")
        end

    end

end

function gpay.saver.DieEncoder(pl)
    pl.activeboosters = {}
    pl:CheckExpires()
    pl.killed = false
    if not pl.donate_weapons then return end
    for k,v in pairs(pl.donate_weapons) do
        if gpay.GetItem(k) and pl:HasItem(k) and v then
            timer.Simple(0.5,function()
                local wep = pl:Give(k)

                wep.donategiven = true

            end)
        end
    end

    if not pl.boosters then return end
    for k,v in pairs(pl.boosters) do
        if gpay.GetItem(k) and pl:HasItem(k) and v then
            timer.Simple(0.5,function() pl.activeboosters[k] = true gpay.boosters[k](pl) end)
        end
    end

end

hook.Add("CanDropWeapon","mrp.CantDrop",function(pl,wep)
	if wep.donategiven then

		return false

	end
end)
hook.Add("PlayerSpawn","gpay.DieEncoder",gpay.saver.DieEncoder)
--The script is written by FOER © 2019