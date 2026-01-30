@tool
extends PanelContainer



var config_path:String=GDAutoBuilderEditorPlugin.get_plugin_path().path_join("plugin_data.cfg")

var _config_file:ConfigFile:
	get():
		if _config_file_cache==null:
			if FileAccess.file_exists(config_path):
				_config_file_cache=ConfigFile.new()
				_config_file_cache.load(config_path)
			else:
				_config_file_cache=ConfigFile.new()
				save_config_file()
		return _config_file_cache

func save_config_file():
	_config_file_cache.save(config_path)
	EditorInterface.get_resource_filesystem().update_file(config_path)
	pass

##访问建立的缓存
var _config_file_cache:ConfigFile




var website:String:
	get():
		return _config_file.get_value("godot","website","https://github.com/godotengine/godot")
	set(value):
		_config_file.set_value("godot","website",value)
		save_config_file()
		#同步到UI
		if %Website.text!=value:
			%Website.text=value

##Godot源码目录
var godot_source_code_path:String:
	get():
		return _config_file.get_value("godot","source_code_path","")
	set(value):
		_config_file.set_value("godot","source_code_path",value)
		save_config_file()
		#同步到UI
		if %SourceCodeEdit.text!=value:
			%SourceCodeEdit.text=value

##Godot build文件目录
var godot_build_file_path:String:
	get():
		return _config_file.get_value("godot","build_file_path","")
	set(value):
		_config_file.set_value("godot","build_file_path",value)
		save_config_file()
		#同步到UI
		if %BuildEdit.text!=value:
			%BuildEdit.text=value




enum Platform{
	WINDOWS,
	LINUX,
	WEB,
	IOS,
	ANDROID_ARM_32,
	ANDROID_ARM_64,
	MACOS_X86_64,
	MACOS_ARM_64,
}
##导出选项
var platform:Platform:
	get():
		return _config_file.get_value("godot","export_platform",0)
	set(value):
		_config_file.set_value("godot","export_platform",value)
		save_config_file()
		if %PlatformOption.selected!=value:
			%PlatformOption.select(value)


enum Optimize{
	DISABLED,
	SIZE,
	SIZE_EXTRA
}
##优化
var optimize:Optimize:
	get():
		return _config_file.get_value("godot","optimize",0)
	set(value):
		_config_file.set_value("godot","optimize",value)
		save_config_file()
		if %OptimizeOption.selected!=value:
			%OptimizeOption.select(value)
	
##使用线程
var use_thread:bool:
	get():
		return _config_file.get_value("godot","use_thread",true)
	set(value):
		_config_file.set_value("godot","use_thread",value)
		save_config_file()
		if %UseThreadCheckBox.button_pressed!=value:
			%UseThreadCheckBox.set_pressed_no_signal(value)

##使用lto
var use_lto:bool:
	get():
		return _config_file.get_value("godot","use_lto",true)
	set(value):
		_config_file.set_value("godot","use_lto",value)
		save_config_file()
		if %UseLtoCheckBox.button_pressed!=value:
			%UseLtoCheckBox.set_pressed_no_signal(value)

##使用调试
var use_debug:bool:
	get():
		return _config_file.get_value("godot","use_debug",true)
	set(value):
		_config_file.set_value("godot","use_debug",value)
		save_config_file()
		if %UseDebugCheckBox.button_pressed!=value:
			%UseDebugCheckBox.set_pressed_no_signal(value)


func _ready() -> void:
	godot_build_file_path=godot_build_file_path
	godot_source_code_path=godot_source_code_path
	platform=platform
	optimize=optimize
	use_thread=use_thread
	use_lto=use_lto
	use_debug=use_debug
	website=website
	
	pass










func _on_select_source_code_btn_pressed() -> void:
	%Source.popup()
	pass # Replace with function body.


func _on_select_build_btn_pressed() -> void:
	%Build.popup()
	pass # Replace with function body.



func _on_build_file_selected(path: String) -> void:
	godot_build_file_path=path
	pass # Replace with function body.


func _on_source_dir_selected(dir: String) -> void:
	godot_source_code_path=dir
	pass # Replace with function body.


func _on_source_code_edit_text_changed(new_text: String) -> void:
	if godot_source_code_path!=new_text:
		godot_source_code_path=new_text
	pass # Replace with function body.


func _on_build_edit_text_changed(new_text: String) -> void:
	if godot_build_file_path!=new_text:
		godot_build_file_path=new_text
	pass # Replace with function body.


func _on_platform_option_item_selected(index: int) -> void:
	if platform!=index:
		platform=index
	pass # Replace with function body.


func _on_optimize_option_item_selected(index: int) -> void:
	if optimize!=index:
		optimize=index
	pass # Replace with function body.


func _on_use_thread_check_box_toggled(toggled_on: bool) -> void:
	if use_thread!=toggled_on:
		use_thread=toggled_on
	pass # Replace with function body.


func _on_use_lto_check_box_toggled(toggled_on: bool) -> void:
	if use_lto!=toggled_on:
		use_lto=toggled_on
	pass # Replace with function body.


func _on_use_debug_check_box_toggled(toggled_on: bool) -> void:
	if use_debug!=toggled_on:
		use_debug=toggled_on
	pass # Replace with function body.



func _on_website_text_changed(new_text: String) -> void:
	if website!=new_text:
		website=new_text
	pass # Replace with function body.





##生成参数表，如果成功则返回true
func generate_arguments(arguments:PackedStringArray)->bool:
	if godot_source_code_path=="":
		return false
	arguments.append("--directory=%s"%godot_source_code_path)
	
	if godot_build_file_path=="":
		return false
	arguments.append("build_profile=%s"%godot_build_file_path)
	match platform:
		Platform.WINDOWS:
			arguments.append("platform=windows")
		Platform.LINUX:
			arguments.append("platform=linuxbsd")
		Platform.WEB:
			arguments.append("platform=web")
		Platform.IOS:
			arguments.append("platform=ios")
			arguments.append("generate_bundle=yes")
		Platform.ANDROID_ARM_32:
			arguments.append("platform=android")
			arguments.append("arch=arm32")
		Platform.ANDROID_ARM_64:
			arguments.append("platform=android")
			arguments.append("arch=arm64")
			arguments.append("generate_android_binaries=yes")
		Platform.MACOS_X86_64:
			arguments.append("platform=macos")
			arguments.append("arch=x86_64")
		Platform.MACOS_ARM_64:
			arguments.append("platform=macos")
			arguments.append("arch=arm64")
		_:
			return false
	match optimize:
		Optimize.DISABLED:
			pass
		Optimize.SIZE:
			arguments.append("optimize=size")
		Optimize.SIZE_EXTRA:
			arguments.append("optimize=size_extra")
		_:
			return false
	if use_thread:
		arguments.append("threads=yes")
	else:
		arguments.append("threads=no")
	if use_lto:
		arguments.append("lto=full")
	if use_debug:
		arguments.append("target=template_debug")
	else:
		arguments.append("target=template_release")
	
	return true

var cache_dictionary:Dictionary

#运行导出模板构建
func run_build():
	var arguments:PackedStringArray=PackedStringArray()
	var use_arguments=generate_arguments(arguments)
	if not use_arguments:
		push_error("参数不全或不合法")
		return
	cache_dictionary=OS.execute_with_pipe("scons.exe",arguments,false)
	%buildMessage.text=""
	%BuildMessageWindow.size=get_viewport_rect().size*Vector2(0.8,0.8)
	%BuildMessageWindow.popup()
	
	
func _process(delta: float) -> void:
	if not cache_dictionary.is_empty():
		%buildMessage.text+=cache_dictionary["stdio"].get_as_text()
		if OS.is_process_running(cache_dictionary["pid"]):
			%buildMessage.text+=cache_dictionary["stdio"].get_as_text(true)
			pass
		else:
			cache_dictionary={}
			build_finished()
			pass
	pass
##构建完成后进行的操作
func build_finished():
	
	
	
	
	pass
func _on_run_btn_pressed() -> void:
	run_build()
	pass # Replace with function body.


func _on_build_message_window_close_requested() -> void:
	if not cache_dictionary.is_empty():
		OS.kill(cache_dictionary["pid"])
		cache_dictionary={}
	%BuildMessageWindow.hide()


func _on_open_output_pressed() -> void:
	OS.shell_show_in_file_manager(godot_source_code_path.path_join("/bin"),true)
	pass # Replace with function body.

##获取当前引擎的版本构建哈希标识
func get_godot_hash()->String:
	return Engine.get_version_info()["hash"]

##获取源码下载路径
func get_source_code_download_path()->String:
	#https://github.com/godotengine/godot/archive/%s.zip
	return website.path_join("archive/%s.zip"%[get_godot_hash()])


func _on_download_source_code_btn_pressed() -> void:
	pass # Replace with function body.


func _on_download_source_code_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.
