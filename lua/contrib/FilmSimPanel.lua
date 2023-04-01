local darktable = require 'darktable'

local function find_style(style_name)
    for _, s in ipairs(darktable.styles) do
        if s.name == style_name then
            return s
        end
    end
    return nil
end


local function apply_style(style_name, image)
    local style = find_style(style_name)
    darktable.print("applying style " .. style_name)
    if darktable.gui.current_view() == darktable.gui.views.lighttable then
        darktable.styles.apply(style, image)
    elseif darktable.gui.current_view() == darktable.gui.views.darkroom then
        -- for some reason, darktable.styles.apply crashes darktable
        -- half the time. Thus, use darktable.gui.action instead (and
        -- escape forbidden characters in the style name)
        darktable.gui.action("global/styles/" .. style_name:gsub("/", "-"), 0, "", "", 1.0)
    else
        darktable.print_error("[FilmSimPanel] could not apply style in " ..
                              tostring(darktable.gui.current_view) .. " view")
        return
    end
    darktable.print_log("[FilmSimPanel] applying style " .. style_name)
end


local function apply_style_to_selection(style_name)
    local images = darktable.gui.selection()
    if #images == 0 then
        darktable.print(_("Please select an image"))
    else
        for idx, image in ipairs(images) do
            local extension = image.filename:lower():match("%.[a-z]+$")
            if extension == ".raf" and image.exif_maker == "FUJIFILM" and find_style("Fuji/" .. style_name) then
                apply_style("Fuji/" .. style_name, image)
            elseif extension == ".dng" and image.exif_maker == "RICOH IMAGING COMPANY, LTD." and find_style("Ricoh/" .. style_name) then
                apply_style("Ricoh/" .. style_name, image)
            elseif find_style(style_name) then
                apply_style(style_name, image)
            else
                darktable.print("no style " .. style_name)
                darktable.print_error("[FilmSimPanel] could not locate style " .. style_name ..
                                      " for " .. image.exif_maker .. " image")
            end
        end
    end
end


darktable.register_lib(
    "FilmSimPanel",
    "Film Simulations",
    true, -- expandable
    false, -- resettable
    { -- containers
        [darktable.gui.views.lighttable] = { "DT_UI_CONTAINER_PANEL_RIGHT_CENTER", 100 },
        [darktable.gui.views.darkroom] = { "DT_UI_CONTAINER_PANEL_LEFT_CENTER", 100 }
    },
    darktable.new_widget("box") { -- widget
        orientation = "vertical",
        reset_callback = nil,
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                label = "Provia",
                tooltip = "This is your camera’s default Film Simulation mode and is a good general-purpose setting that’s suitable for most subjects. It provides faithful color reproduction with moderate contrast and sharpness.",
                name = "film_sim_panel_provia_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Astia",
                tooltip = "Like the Velvia Film Simulation mode, ASTIA also delivers vibrant colors with extra saturation, but its contrast is softer, making this a good choice for fashion, interiors, and even portraits. The original FUJICHROME ASTIA boasted the softest tonal reproduction in its class, and was able to reproduce the most delicate of details.",
                name = "film_sim_panel_astia_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Velvia",
                tooltip = "One of our most famous films is FUJICHROME Velvia: a reversal film (ie one that produces transparencies or ‘slides’) that delivers vibrant images with lots of impact. The Film Simulation mode does the same, with a boost in color saturation and contrast that is great for landscape and nature photography.",
                name = "film_sim_panel_velvia_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Classic Chrome",
                tooltip = "This Film Simulation mode is not named after a specific FUJICHROME or FUJICOLOR product, but instead mimics the ambience of documentary-style magazine photography from decades past. It has slightly desaturated colors (especially reds and greens) with harder shadow contrast, resulting in a timeless, subdued look that works well with dramatic lighting and retro-style subjects, as well as reportage projects.",
                name = "film_sim_panel_classic_chrome_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                label = "Pro Neg High",
                tooltip = "Designed for fashion and portrait photography, PRO Neg. Hi features soft skin tones, but offers a little more color saturation and harder shadows than its sibling, PRO Neg. Std. It’s great for emphasizing line, form, and texture, and offers slightly enhanced contrast across the board.",
                name = "film_sim_panel_pro_neg_high_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Pro Neg Std",
                tooltip = "This Film Simulation mode is a good choice for portraits, as it’s known for delivering soft contrast and beautiful skin tones. Colors are somewhat muted, making it a good option for lifestyle images and even street photography. This is a subtle option, able to record the most delicate of differences between colors and works well when the photographer has complete control over lighting.",
                name = "film_sim_panel_pro_neg_std_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Eterna",
                tooltip = "One for the filmmakers, ETERNA is named after the classic film industry emulsion of the same name. It delivers understated colors, extended dynamic range, and flat contrast. A perfect choice when color grading in post-production is desired.",
                name = "film_sim_panel_eterna_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Ricoh Standard",
                name = "film_sim_panel_ricoh_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                label = "Positive Film",
                name = "film_sim_panel_positive_film_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Negative Film",
                name = "film_sim_panel_negative_film_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Vivid",
                name = "film_sim_panel_vivid_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Retro",
                name = "film_sim_panel_retro_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                label = "DR100",
                name = "film_sim_panel_dr100_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "DR200",
                name = "film_sim_panel_dr200_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "DR400",
                name = "film_sim_panel_dr400_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                label = "Shadows+1",
                name = "film_sim_panel_shadows_plus_one_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Shadows=0",
                name = "film_sim_panel_shadows_zero_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Shadows-1",
                name = "film_sim_panel_shadows_minus_one_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Shadows-2",
                name = "film_sim_panel_shadows_minus_two_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                label = "Exposure+1",
                name = "film_sim_panel_exposure_plus_one_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Exposure+0.5",
                name = "film_sim_panel_exposure_plus_half_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Exposure=0",
                name = "film_sim_panel_exposure_zero_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
            darktable.new_widget("button") {
                label = "Exposure-0.5",
                name = "film_sim_panel_exposure_minus_half_button",
                clicked_callback = function(source)
                    apply_style_to_selection(source.label)
                end
            },
        },
    },
    nil, -- view_enter
    nil  -- view_leave
)
