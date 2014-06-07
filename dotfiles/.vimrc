set encoding=utf-8
set nocompatible

" Pathogen
execute pathogen#infect()
execute pathogen#helptags()

"Ctrl-P config
:let g:ctrlp_map = '<C-P>'
:let g:ctrlp_match_window_bottom = 0
:let g:ctrlp_match_window_reversed = 0
:let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
:let g:ctrlp_working_path_mode = 0
:let g:ctrlp_dotfiles = 1
:let g:ctrlp_switch_buffer = 0

"Vdebug config
:let g:vdebug_options = {}
:let g:vdebug_options["watch_window_style"] = 'compact'

"Powerline config
set laststatus=2
set t_Co=256
