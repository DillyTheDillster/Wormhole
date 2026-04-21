local jackpot_playing = false --ear protection
local extrahand_playing = false
local wormhole_playing = false
local hyperspace_playing = false

SMODS.Joker {
    key = "spacecadet",
    rarity = 3,
    cost = 10,
    config = {
        extra = {
            prob = 1,
            odds = 3,
            dollars = 15,
            hands = 1,
            retrig = false,
            retriggers = 1,
            xmult = 2
        }
    },
    ppu_team = { "VV" },
    ppu_coder = { "Iso", "FireIce" },
    attributes = {"chance", "economy", "hands", "xmult", "retrigger", "space"},
    atlas = 'VVjokers',
    pos = {x = 0, y = 2},
    loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.prob, card.ability.extra.odds, 'vv_cadet')
        return {
            vars = {
                num, denom, card.ability.extra.dollars, card.ability.extra.hands, card.ability.extra.xmult, card.ability.extra.retriggers 
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before then
            ret = {}
            if SMODS.pseudorandom_probability(card, "award_a", card.ability.extra.prob, card.ability.extra.odds) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                ret.dollars = card.ability.extra.dollars
                if not jackpot_playing then 
                    play_sound('worm_jackpot', 1, 1)
                    jackpot_playing = true
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 1,
                        blocking = false,
                        blockable = false,
                        func = function()
                            jackpot_playing = false
                        end
                    }))
                end
            end
            if SMODS.pseudorandom_probability(card, "award_b", card.ability.extra.prob, card.ability.extra.odds) then
                ease_hands_played(card.ability.extra.hands)
                ret.message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}}
                ret.colour = G.C.BLUE
                if not extrahand_playing then 
                    play_sound('worm_extrahand', 1, 1)
                    extrahand_playing = true
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 1,
                        blocking = false,
                        blockable = false,
                        func = function()
                            extrahand_playing = false
                        end
                    }))
                end
            end
            if SMODS.pseudorandom_probability(card, "b", card.ability.extra.prob, card.ability.extra.odds) then 
                card.ability.extra.retrig = true
                ret.message = "Wormhole!"
                if not wormhole_playing then 
                    play_sound('worm_wormhole', 1, 1)
                    wormhole_playing = true
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 1,
                        blocking = false,
                        blockable = false,
                        func = function()
                            wormhole_playing = false
                        end
                    }))
                end
            end
            return ret
        end
        if context.repetition and card.ability.extra.retrig == true then
            card.ability.extra.retrig = false
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
        if context.individual and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, "c", card.ability.extra.prob, card.ability.extra.odds) then
                if not hyperspace_playing then 
                    play_sound('worm_hyperspace', 1, 1)
                    hyperspace_playing = true
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 1,
                        blocking = false,
                        blockable = false,
                        func = function()
                            hyperspace_playing = false
                        end
                    }))
                end    
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end
}
