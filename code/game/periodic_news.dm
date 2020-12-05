// This system defines news that will be displayed in the course of a round.
// Uses BYOND's type system to put everything into a nice format

/datum/news_announcement
	var
		round_time // time of the round at which this should be announced, in seconds
		message // body of the message
		author = "Transtar Company"
		channel_name = "Transtar Secrets"
		can_be_redacted = 0
		message_type = "Story"

	revolution_inciting_event

		paycuts_suspicion
			round_time = 60*10
			message = {"We need to increase the reload speed of the GYPSUM cannon. The starters on
						this device work well, Oh-Oh-Oh-Oh-Oh-very slowly."}
			author = "Mary"

		human_experiments
			round_time = 60*40
			message = {"As you can see, we are close to completion. As soon as the cooling system is
						optimized and connected to the K-beam firing node, the prototypes will be sent
						to Earth. The tests are going according to plan. Preliminary results show promising
						effects on molecular structures. The weapon has not yet been tested on live targets."}
			author = "Lane Carpenter"

		paycuts_confirmation
			round_time = 60*90
			message = {"1.Don't forget that Blind Giants can call for help using the Ganges.
						2. Don't let Flag dusterus use the white gem against necro.
						3. +1 block bonus for everyone who solves the Drip puzzle"}
			author = "Giant's citadel"

	bluespace_research

		announcement
			round_time = 60*20
			message = {"Coral is a complex neural structural network that (according to Alex) stores the souls
						of all its victims (a translation jamb, because the original refers to the psyche or mind).
						Weavers weave them out of the air and the minds of their dead victims. It emits a neural
						signal directed towards alpha Typhon for its arrival."}

	random_junk

		cheesy_honkers
			author = "Assistant Editor Carl Ritz"
			channel_name = "The Gibson Gazette"
			message = {"Do cheesy honkers increase risk of having a miscarriage? Several health administrations
						say so!"}
			round_time = 60 * 15

		net_block
			author = "Assistant Editor Carl Ritz"
			channel_name = "The Gibson Gazette"
			message = {"Several corporations banding together to block access to 'wetskrell.nt', site administrators
			claiming violation of net laws."}
			round_time = 60 * 50

		found_ssd
			channel_name = "Nyx Daily"
			author = "Doctor Eric Hanfield"

			message = {"Several people have been found unconscious at their terminals. It is thought that it was due
						to a lack of sleep or of simply migraines from staring at the screen too long. Camera footage
						reveals that many of them were playing games instead of working and their pay has been docked
						accordingly."}
			round_time = 60 * 90

	lotus_tree

		explosions
			channel_name = "Transtar facts"
			author = "Reporter Leland H. Howards"

			message = {"The newly-christened civillian transport Lotus Tree suffered two very large explosions near the
						bridge today, and there are unconfirmed reports that the death toll has passed 50. The cause of
						the explosions remain unknown, but there is speculation that it might have something to do with
						the recent change of regulation in the Moore-Lee Corporation, a major funder of the ship, when M-L
						announced that they were officially acknowledging inter-species marriage and providing couples
						with marriage tax-benefits."}
			round_time = 60 * 30

	food_riots

		breaking_news
			channel_name = "Transtar Facts"
			author = "Reporter Ivan Satyukov"

			message = {"Breaking news: Food riots have broken out throughout the Refuge asteroid colony in the Tenebrae
						Lupus system. This comes only hours after NanoTrasen officials announced they will no longer trade with the
						colony, citing the increased presence of \"hostile factions\" on the colony has made trade too dangerous to
						continue. Transtar officials have not given any details about said factions. More on that at the top of
						the hour."}
			round_time = 60 * 10

		more
			channel_name = "Transtar Worlds"
			author = "Reporter Colten Callision"

			message = {"More on the Refuge food riots: The Refuge Council has condemned NanoTrasen's withdrawal from
			the colony, claiming \"there has been no increase in anti-NanoTrasen activity\", and \"\[the only] reason
			NanoTrasen withdrew was because the \[Tenebrae Lupus] system's Phoron deposits have been completely mined out.
			We have little to trade with them now\". NanoTrasen officials have denied these allegations, calling them
			\"further proof\" of the colony's anti-NanoTrasen stance. Meanwhile, Refuge Security has been unable to quell
			the riots. More on this at 6."}
			round_time = 60 * 60


var/global/list/newscaster_standard_feeds = list(/datum/news_announcement/bluespace_research, /datum/news_announcement/lotus_tree, /datum/news_announcement/random_junk,  /datum/news_announcement/food_riots)

proc/process_newscaster()
	check_for_newscaster_updates(SSticker.mode.newscaster_announcements)

var/global/tmp/announced_news_types = list()
proc/check_for_newscaster_updates(type)
	for(var/subtype in typesof(type)-type)
		var/datum/news_announcement/news = new subtype()
		if(news.round_time * 10 <= world.time && !(subtype in announced_news_types))
			announced_news_types += subtype
			announce_newscaster_news(news)

proc/announce_newscaster_news(datum/news_announcement/news)
	var/datum/feed_channel/sendto
	for(var/datum/feed_channel/FC in news_network.network_channels)
		if(FC.channel_name == news.channel_name)
			sendto = FC
			break

	if(!sendto)
		sendto = new /datum/feed_channel
		sendto.channel_name = news.channel_name
		sendto.author = news.author
		sendto.locked = 1
		sendto.is_admin_channel = 1
		news_network.network_channels += sendto

	var/author = news.author ? news.author : sendto.author
	news_network.SubmitArticle(news.message, author, news.channel_name, null, !news.can_be_redacted, news.message_type)
