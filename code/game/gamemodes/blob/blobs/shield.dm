/obj/structure/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_shield"
	desc = "Some blob creature thingy"
	max_integrity = 150
	brute_resist = 0.25
	explosion_block = 3
	explosion_vertical_block = 2
	atmosblock = TRUE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 90)

/obj/structure/blob/shield/core
	point_return = 0


/obj/structure/blob/shield/check_integrity()
	var/old_compromised_integrity = compromised_integrity
	if(obj_integrity < max_integrity * 0.5)
		compromised_integrity = TRUE
	else
		compromised_integrity = FALSE
	if(old_compromised_integrity != compromised_integrity)
		update_state()
		update_appearance(UPDATE_NAME|UPDATE_DESC|UPDATE_ICON_STATE)


/obj/structure/blob/shield/update_state()
	if(compromised_integrity)
		atmosblock = FALSE
	else
		atmosblock = TRUE
	air_update_turf(1)


/obj/structure/blob/shield/update_name(updates = ALL)
	. = ..()
	if(compromised_integrity)
		name = "weakened [initial(name)]"
	else
		name = initial(name)


/obj/structure/blob/shield/update_desc(updates = ALL)
	. = ..()
	if(compromised_integrity)
		desc = "A wall of twitching tendrils."
	else
		desc = initial(desc)


/obj/structure/blob/shield/update_icon_state()
	if(compromised_integrity)
		icon_state = "[initial(icon_state)]_damaged"
	else
		icon_state = initial(icon_state)


/obj/structure/blob/shield/reflective
	name = "reflective blob"
	desc = "A solid wall of slightly twitching tendrils with a reflective glow."
	icon_state = "blob_glow"
	max_integrity = 100
	brute_resist = 0.5
	explosion_block = 2
	explosion_vertical_block = 1
	point_return = 9
	flags_2 = CHECK_RICOCHET_2

/obj/structure/blob/shield/reflective/handle_ricochet(obj/item/projectile/P)
	var/turf/p_turf = get_turf(P)
	var/face_direction = get_dir(src, p_turf)
	var/face_angle = dir2angle(face_direction)
	var/incidence_s = GET_ANGLE_OF_INCIDENCE(face_angle, (P.Angle + 180))
	if(abs(incidence_s) > 90 && abs(incidence_s) < 270)
		return FALSE
	var/new_angle_s = SIMPLIFY_DEGREES(face_angle + incidence_s)
	P.set_angle(new_angle_s)
	visible_message("<span class='warning'>[P] reflects off [src]!</span>")
	return TRUE
