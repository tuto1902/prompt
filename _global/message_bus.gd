extends Node

@warning_ignore("unused_signal")
signal player_ready

@warning_ignore("unused_signal")
signal player_interacted(player: Player)

@warning_ignore("unused_signal")
signal player_healed(amount: float)

@warning_ignore("unused_signal")
signal player_died()

@warning_ignore("unused_signal")
signal player_ability_unlocked(ability: String)

@warning_ignore("unused_signal")
signal player_ability_locked(ability: String)

@warning_ignore("unused_signal")
signal input_hint_changed(action: String, hint: String)

@warning_ignore("unused_signal")
signal prompt_requested()

@warning_ignore("unused_signal")
signal prompt_response_collected(terminal_id: Enums.TERMINALS, save_game: bool)

@warning_ignore("unused_signal")
signal prompt_response_delivered()

@warning_ignore("unused_signal")
signal open_door(door_name: Enums.DOORS)

@warning_ignore("unused_signal")
signal close_door(door_name: Enums.DOORS)

@warning_ignore("unused_signal")
signal player_heath_changed(health: float, max_health: float)

@warning_ignore("unused_signal")
signal game_paused

@warning_ignore("unused_signal")
signal game_exited
