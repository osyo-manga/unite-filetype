scriptencoding utf-8

function! unite#sources#filetype#define()
	return [s:source, s:source_new]
endfunction


function! s:filetypes()
	if !exists("s:filetypes_cache")
		let s:filetypes_cache = unite#util#uniq(map(split(
\			globpath(&rtp, "syntax/**/*.vim") . "\n" .
\			globpath(&rtp, "indent/**/*.vim"), "\n"),
\			"fnamemodify(v:val, ':t:r')"))
	endif
	return copy(s:filetypes_cache)
endfunction


let s:source = {
\	"name" : "filetype",
\	"description" : "candidates from all filetype disp & set the filetype",
\	"default_action" : "set_filetype",
\	"action_table" : {
\		"set_filetype" : {
\			"description" : "set filetype=",
\			"is_selectable" : 0,
\		},
\	}
\}


function! s:source.action_table.set_filetype.func(candidate)
	let bufnr = get(unite#get_current_unite(), "prev_bufnr", bufnr("%"))
	call setbufvar(bufnr, "&filetype", a:candidate.action__filetype)
endfunction


function! s:source.change_candidates(args, context)
	return map(s:filetypes(),'{
\		"word" : v:val,
\		"action__filetype" : v:val
\}')
endfunction

let s:source_new = deepcopy(s:source)
let s:source_new.name = "filetype/new"
let s:source_new.description = "candidates from input filetype & set the filetype"

function! s:source_new.change_candidates(args, context)
	return ((a:context.input != "" &&
\		index(s:filetypes(), a:context.input) < 0) ? [{
\		"word" : "[new filetype] " . a:context.input,
\		"action__filetype" : a:context.input
\}] : [])
endfunction

