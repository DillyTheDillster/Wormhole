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
            retriggers = 1,
            xmult = 2
        }
    },
    ppu_team = { "VV" },
    ppu_coder = { "Iso", "FireIce" },
    atlas = 'VVjokers',
    pos = {x = 0, y = 2},
    loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.prob, card.ability.extra.odds, 'vv_cadet')
        return {
            vars = {
                num, denom, card.ability.extra.dollars, card.ability.extra.hands, card.ability.extra.retriggers, card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        local retrig_all = false
        if context.before then
            if SMODS.pseudorandom_probability(card, "award_a", card.ability.extra.prob, card.ability.extra.odds) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars
                },
                play_sound('worm_jackpot', 1, 1)
            end
            if SMODS.pseudorandom_probability(card, "award_b", card.ability.extra.prob, card.ability.extra.odds) then
                ease_hands_played(card.ability.extra.hands)
                return {
                    message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}},
                    colour = G.C.BLUE
                },
                play_sound('worm_extrahand', 1, 1)
            end
            if SMODS.pseudorandom_probability(card, "b", card.ability.extra.prob, card.ability.extra.odds) then 
                retrig_all = true
                return {
                    message = "Wormhole!",
                },
                play_sound('worm_wormhole', 1, 1)
            end
        end
        if context.repetition and retrig_all == true then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
        if context.individual and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, "c", card.ability.extra.prob, card.ability.extra.odds) then
                return {
                    xmult = card.ability.extra.xmult,
                },
                play_sound('worm_hyperspace', 1, 1)
            end
        end
        if context.after then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.1,
                func = function()
                    retrig_all = false
                    return true
                end
            }))
        end
    end
}
