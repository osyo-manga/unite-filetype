scriptencoding utf-8

function! unite#sources#filetype#define()
	return s:source
endfunction


function! s:filetypes()
	if !exists("s:filetypes_cache")
		let s:filetypes_cache = s:unique(map(split(globpath(&rtp, "syntax/**/*.vim") . "\n" . globpath(&rtp, "indent/**/*.vim"), "\n"), "fnamemodify(v:val, ':t:r')"))
	endif
	return copy(s:filetypes_cache)
endfunction


let s:source = {
\	"name" : "filetype",
\	"description" : "all filetype disp & set filetype",
\	"default_action" : "set_filetype",
\	"action_table" : {
\		"set_filetype" : {
\			"description" : "set filetype=",
\			"is_selectable" : 0,
\		},
\	}
\}


function! s:source.action_table.set_filetype.func(candidates)
	let bufnr = get(get(b:, "unite", {}), "prev_bufnr", bufnr("%"))
	call setbufvar(bufnr, "&filetype", a:candidates.action__filetype)
endfunction


function! s:source.gather_candidates(args, context)
	return map(s:filetypes(),'{
\		"word" : v:val,
\		"action__filetype" : v:val
\}')
endfunction



