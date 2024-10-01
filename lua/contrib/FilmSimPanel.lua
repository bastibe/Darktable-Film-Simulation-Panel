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
    darktable.styles.apply(style, image)
    darktable.print_log("[FilmSimPanel] applying style " .. style_name)
end


local function apply_style_to_selection(style_name)
    local images = darktable.gui.selection()
    if #images == 0 then
        darktable.print("Please select an image")
    else
        for idx, image in ipairs(images) do
            local extension = image.filename:lower():match("%.[a-z]+$")
            if find_style(style_name) then
                apply_style(style_name, image)
            else
                darktable.print("no style " .. style_name)
                darktable.print_error("[FilmSimPanel] could not locate style " .. style_name)
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
                tooltip = "This is your camera’s default Film Simulation mode and is a good general-purpose setting that’s suitable for most subjects. It provides faithful color reproduction with moderate contrast and sharpness.",
                name = "film_sim_panel_provia_button",
                image = darktable.configuration.config_dir .. "/icons/provia.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Provia")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Like the Velvia Film Simulation mode, ASTIA also delivers vibrant colors with extra saturation, but its contrast is softer, making this a good choice for fashion, interiors, and even portraits. The original FUJICHROME ASTIA boasted the softest tonal reproduction in its class, and was able to reproduce the most delicate of details.",
                name = "film_sim_panel_astia_button",                
                image = darktable.configuration.config_dir .. "/icons/astia.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Astia")
                end
            },
            darktable.new_widget("button") {
                tooltip = "One of our most famous films is FUJICHROME Velvia: a reversal film (ie one that produces transparencies or ‘slides’) that delivers vibrant images with lots of impact. The Film Simulation mode does the same, with a boost in color saturation and contrast that is great for landscape and nature photography.",
                name = "film_sim_panel_velvia_button",
                image = darktable.configuration.config_dir .. "/icons/velvia.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Velvia")
                end
            },
            darktable.new_widget("button") {
                tooltip = "This Film Simulation mode is not named after a specific FUJICHROME or FUJICOLOR product, but instead mimics the ambience of documentary-style magazine photography from decades past. It has slightly desaturated colors (especially reds and greens) with harder shadow contrast, resulting in a timeless, subdued look that works well with dramatic lighting and retro-style subjects, as well as reportage projects.",
                name = "film_sim_panel_classic_chrome_button",
                image = darktable.configuration.config_dir .. "/icons/classic chrome.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Classic Chrome")
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                tooltip = "Designed for fashion and portrait photography, PRO Neg. Hi features soft skin tones, but offers a little more color saturation and harder shadows than its sibling, PRO Neg. Std. It’s great for emphasizing line, form, and texture, and offers slightly enhanced contrast across the board.",
                name = "film_sim_panel_pro_neg_high_button",
                image = darktable.configuration.config_dir .. "/icons/pro neg high.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Pro Neg High")
                end
            },
            darktable.new_widget("button") {
                tooltip = "This Film Simulation mode is a good choice for portraits, as it’s known for delivering soft contrast and beautiful skin tones. Colors are somewhat muted, making it a good option for lifestyle images and even street photography. This is a subtle option, able to record the most delicate of differences between colors and works well when the photographer has complete control over lighting.",
                name = "film_sim_panel_pro_neg_std_button",
                image = darktable.configuration.config_dir .. "/icons/pro neg std.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Pro Neg Std")
                end
            },
            darktable.new_widget("button") {
                tooltip = "One for the filmmakers, ETERNA is named after the classic film industry emulsion of the same name. It delivers understated colors, extended dynamic range, and flat contrast. A perfect choice when color grading in post-production is desired.",
                name = "film_sim_panel_eterna_button",
                image = darktable.configuration.config_dir .. "/icons/eterna.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Eterna")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Ricoh Standard",
                name = "film_sim_panel_eterna_bleach_bypass_button",
                image = darktable.configuration.config_dir .. "/icons/eterna bleach bypass.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Eterna Bleach Bypass")
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                tooltip = "Designed for fashion and portrait photography, PRO Neg. Hi features soft skin tones, but offers a little more color saturation and harder shadows than its sibling, PRO Neg. Std. It’s great for emphasizing line, form, and texture, and offers slightly enhanced contrast across the board.",
                name = "film_sim_panel_classic_neg_button",
                image = darktable.configuration.config_dir .. "/icons/classic neg.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Classic Neg")
                end
            },
            darktable.new_widget("button") {
                tooltip = "This Film Simulation mode is a good choice for portraits, as it’s known for delivering soft contrast and beautiful skin tones. Colors are somewhat muted, making it a good option for lifestyle images and even street photography. This is a subtle option, able to record the most delicate of differences between colors and works well when the photographer has complete control over lighting.",
                name = "film_sim_panel_nostalgic_neg_button",
                image = darktable.configuration.config_dir .. "/icons/nostalgic neg.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Nostalgic Neg")
                end
            },
            darktable.new_widget("button") {
                tooltip = "One for the filmmakers, ETERNA is named after the classic film industry emulsion of the same name. It delivers understated colors, extended dynamic range, and flat contrast. A perfect choice when color grading in post-production is desired.",
                name = "film_sim_panel_reala_ace_button",
                image = darktable.configuration.config_dir .. "/icons/reala ace.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Fuji/Reala Ace")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Ricoh Standard",
                name = "film_sim_panel_ricoh_button",
                image = darktable.configuration.config_dir .. "/icons/ricoh.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Ricoh/Ricoh Standard")
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                tooltip = "Positive Film",
                name = "film_sim_panel_positive_film_button",
                image = darktable.configuration.config_dir .. "/icons/positive film.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Ricoh/Positive Film")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Negative Film",
                name = "film_sim_panel_negative_film_button",
                image = darktable.configuration.config_dir .. "/icons/negative film.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Ricoh/Negative Film")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Vivid",
                name = "film_sim_panel_vivid_button",
                image = darktable.configuration.config_dir .. "/icons/vivid.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Ricoh/Vivid")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Retro",
                name = "film_sim_panel_retro_button",
                image = darktable.configuration.config_dir .. "/icons/retro.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Ricoh/Retro")
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                tooltip = "DR100",
                name = "film_sim_panel_dr100_button",
                image = darktable.configuration.config_dir .. "/icons/DR100.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("DR100")
                end
            },
            darktable.new_widget("button") {
                tooltip = "DR200",
                name = "film_sim_panel_dr200_button",
                image = darktable.configuration.config_dir .. "/icons/DR200.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("DR200")
                end
            },
            darktable.new_widget("button") {
                tooltip = "DR400",
                name = "film_sim_panel_dr400_button",
                image = darktable.configuration.config_dir .. "/icons/DR400.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("DR400")
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                tooltip = "Shadows+1",
                name = "film_sim_panel_shadows_plus_one_button",
                image = darktable.configuration.config_dir .. "/icons/shadows+1.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Shadows+1")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Shadows=0",
                name = "film_sim_panel_shadows_zero_button",
                image = darktable.configuration.config_dir .. "/icons/shadows=0.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Shadows=0")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Shadows-1",
                name = "film_sim_panel_shadows_minus_one_button",
                image = darktable.configuration.config_dir .. "/icons/shadows-1.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Shadows-1")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Shadows-2",
                name = "film_sim_panel_shadows_minus_two_button",
                image = darktable.configuration.config_dir .. "/icons/shadows-2.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Shadows-2")
                end
            },
        },
        darktable.new_widget("box") {
            orientation = "horizontal",
            darktable.new_widget("button") {
                tooltip = "Exposure+1",
                name = "film_sim_panel_exposure_plus_one_button",
                image = darktable.configuration.config_dir .. "/icons/exposure+1.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Exposure+1")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Exposure+0.5",
                name = "film_sim_panel_exposure_plus_half_button",
                image = darktable.configuration.config_dir .. "/icons/exposure+0.5.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Exposure+0.5")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Exposure=0",
                name = "film_sim_panel_exposure_zero_button",
                image = darktable.configuration.config_dir .. "/icons/exposure=0.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Exposure=0")
                end
            },
            darktable.new_widget("button") {
                tooltip = "Exposure-0.5",
                name = "film_sim_panel_exposure_minus_half_button",
                image = darktable.configuration.config_dir .. "/icons/exposure-0.5.svg",
                clicked_callback = function(source)
                    apply_style_to_selection("Exposure-0.5")
                end
            },
        },
    },
    nil, -- view_enter
    nil  -- view_leave
)
