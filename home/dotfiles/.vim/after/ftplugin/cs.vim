" Indent on save hook
"autocmd BufWritePre <buffer> call Indent()

" Run dotnet run as make command
" Using dotnet 9 because 8 doesn't work
set makeprg=nix-shell\ -p\ dotnetCorePackages.sdk_9_0\ --command\ \"dotnet\ run\"

" run without rebuilding content to be faster
nnoremap <Leader>r :call job_start('nix-shell -p dotnetCorePackages.sdk_9_0 --command "dotnet run --no-restore"')<CR>
nnoremap <Leader>f :call job_start('nix-shell -p dotnetCorePackages.sdk_9_0 --command "dotnet run"')<CR>

" needed because I don't know how to get method signatures in popups
set noshowmode
