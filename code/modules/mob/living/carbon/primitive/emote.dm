/mob/living/carbon/primitive/emote(var/act,var/m_type=1,var/message = null)

	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = is_muzzled()

	//Emote Cooldown System (it's so simple!)
	// proc/handle_emote_CD() located in [code\modules\mob\emote.dm]
	var/on_CD = 0
	switch(act)
		//Cooldown-inducing emotes
		if("chirp")
			if(istype(src,/mob/living/carbon/primitive/diona))		//Only Diona Nymphs can chirp
				on_CD = handle_emote_CD()								//proc located in code\modules\mob\emote.dm
			else													//Everyone else fails, skip the emote attempt
				return
		if("flip")
			on_CD = handle_emote_CD()				//proc located in code\modules\mob\emote.dm
		//Everything else, including typos of the above emotes
		else
			on_CD = 0	//If it doesn't induce the cooldown, we won't check for the cooldown

	if(on_CD == 1)		// Check if we need to suppress the emote attempt.
		return			// Suppress emote, you're still cooling off.
	//--FalseIncarnate

	switch(act)
		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)


		if ("custom")
			return custom_emote(m_type, message)

		if ("chirp")
			message = "<B>The [src.name]</B> chirps!"
			playsound(src.loc, 'sound/misc/nymphchirp.ogg', 50, 0)
			m_type = 2
		if("sign")
			if (!src.restrained())
				message = text("<B>The [src.name]</B> signs[].", (text2num(param) ? text(" the number []", text2num(param)) : null))
				m_type = 1
		if("scratch")
			if (!src.restrained())
				message = "<B>The [src.name]</B> scratches."
				m_type = 1
		if("whimper")
			if (!muzzled)
				message = "<B>The [src.name]</B> whimpers."
				m_type = 2
		if("roar")
			if (!muzzled)
				message = "<B>The [src.name]</B> roars."
				m_type = 2
		if("tail")
			message = "<B>The [src.name]</B> waves his tail."
			m_type = 1
		if("gasp")
			message = "<B>The [src.name]</B> gasps."
			m_type = 2
		if("shiver")
			message = "<B>The [src.name]</B> shivers."
			m_type = 2
		if("drool")
			message = "<B>The [src.name]</B> drools."
			m_type = 1
		if("paw")
			if (!src.restrained())
				message = "<B>The [src.name]</B> flails his paw."
				m_type = 1
		if("scretch")
			if (!muzzled)
				message = "<B>The [src.name]</B> scretches."
				m_type = 2
		if("choke")
			message = "<B>The [src.name]</B> chokes."
			m_type = 2
		if("moan")
			message = "<B>The [src.name]</B> moans!"
			m_type = 2
		if("nod")
			message = "<B>The [src.name]</B> nods his head."
			m_type = 1
		if("sit")
			message = "<B>The [src.name]</B> sits down."
			m_type = 1
		if("sway")
			message = "<B>The [src.name]</B> sways around dizzily."
			m_type = 1
		if("sulk")
			message = "<B>The [src.name]</B> sulks down sadly."
			m_type = 1
		if("twitch")
			message = "<B>The [src.name]</B> twitches violently."
			m_type = 1
		if("dance")
			if (!src.restrained())
				message = "<B>The [src.name]</B> dances around happily."
				m_type = 1
		if("roll")
			if (!src.restrained())
				message = "<B>The [src.name]</B> rolls."
				m_type = 1
		if("shake")
			message = "<B>The [src.name]</B> shakes his head."
			m_type = 1
		if("gnarl")
			if (!muzzled)
				message = "<B>The [src.name]</B> gnarls and shows his teeth.."
				m_type = 2
		if("jump")
			message = "<B>The [src.name]</B> jumps!"
			m_type = 1
		if("collapse")
			Paralyse(2)
			message = "<B>[src.name]</B> collapses!"
			m_type = 2
		if("deathgasp")
			message = "<B>The [src.name]</B> lets out a faint chimper as it collapses and stops moving..."
			m_type = 1
		if ("flip")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if(src.lying || src.weakened)
						message = "<B>[src]</B> flops and flails around on the floor."
					else
						message = "<B>[src]</B> flips in [M]'s general direction."
						src.SpinAnimation(5,1)
				else
					if(src.lying || src.weakened)
						message = "<B>[src]</B> flops and flails around on the floor."
					else
						message = "<B>[src]</B> does a flip!"
						src.SpinAnimation(5,1)
		if("help")
			var/text = "choke, "
			if(istype(src,/mob/living/carbon/primitive/diona))
				text += "chirp, "
			text += "flip, collapse, dance, deathgasp, drool, gasp, shiver, gnarl, jump, paw, moan, nod, roar, roll, scratch,\nscretch, shake, sign-#, sit, sulk, sway, tail, twitch, whimper"
			src << text
		else
			src << text("Invalid Emote: []", act)
	if ((message && src.stat == 0))
		if(src.client)
			log_emote("[name]/[key] : [message]")
		if (m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(703)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
				//Foreach goto(746)
	return