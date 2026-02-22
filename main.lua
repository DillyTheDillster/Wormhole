Wormhole = SMODS.current_mod

if PotatoPatchUtils then
    local file_blacklist = {
        -- Format entries as `['filename.txt'] = true`
    }

    PotatoPatchUtils.load_files(Wormhole.path .. '/content', Wormhole.id, file_blacklist)
    SMODS.handle_loc_file(Wormhole.path, Wormhole.id)
    PotatoPatchUtils.LOC.init()
end