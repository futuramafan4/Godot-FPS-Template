extends Node
#This singleton is meant to handle all setting changes and saves;

enum BUS {Master, Music, Sfx}

const CONFIG_FILE := "user://config.cfg"

#Default game settings that will be loaded and saved when no file is present;
var default_config: Dictionary = {
	#Volumes are declared in linear energy so we can use a 0-100% slider;
	#0 linear is -inf db, which doesn't support being stored as float
	#so we store an unconverted value
	"master_volume": 1.0,
	"volume_music": 1.0,
	"volume_sfx": 1.0,
	"vsync": true,
	"Fullscreen": false,

	#There may be another setting variables according to your needs
	#e.g. brightness level, input maps, fullscreen or windowed, etc.;
}
func _init():
	load_config()



#Loads saved settings;
func load_config() -> void:
	var cfg = ConfigFile.new()
	var unexistant = cfg.load(CONFIG_FILE) #Checks if the config file exists;
	if unexistant: 
		revert_config(cfg)
		#This function will be recalled by revert_config so let's end it;
		return
	#Apply all the settings to the session already;
	#Volume values are converted to decibels in set_audio();
	set_audio(BUS.Master, cfg.get_value("settings", "master_volume"))
	set_audio(BUS.Music, cfg.get_value("settings", "volume_music"))
	set_audio(BUS.Sfx, cfg.get_value("settings", "volume_sfx"))
	OS.vsync_enabled=(cfg.get_value("settings", "vsync"))
	OS.window_fullscreen=(cfg.get_value("settings", "Fullscreen"))

#Called in the other functions whenever a file is not found;
func revert_config(cfg: ConfigFile):
	#Write default settings to cfg;
	for key in default_config.keys():
		cfg.set_value("settings", key, default_config[str(key)])
	cfg.save(CONFIG_FILE)
	load_config()
	return cfg

#Called whenever a setting is changed by the methods;
#The key and its value should be specified by the method in parameters;
func save_config(setting: String, value):
	var cfg = ConfigFile.new()
	var unexistant = cfg.load(CONFIG_FILE)
	#Check if the file went away during runtime;
	if unexistant: cfg = revert_config(cfg)
	cfg.set_value("settings", setting, value)
	cfg.save(CONFIG_FILE)

func get_config(setting):
	var cfg = ConfigFile.new()
	var unexistant = cfg.load(CONFIG_FILE)
	if unexistant: cfg = revert_config(cfg)
	var value = cfg.get_value("settings", setting)
	return value

func set_audio(bus, value):
	AudioServer.set_bus_volume_db(bus, linear2db(value))
