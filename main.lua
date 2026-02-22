Wormhole = SMODS.current_mod

if PotatoPatchUtils then
    PotatoPatchUtils.load_files(Wormhole.path .. '/content', Wormhole.id)
    SMODS.handle_loc_file(Wormhole.path, Wormhole.id)
    PotatoPatchUtils.LOC.init()
end