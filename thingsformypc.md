'''
{
    "workbench.colorTheme": "Catppuccin Mocha",
    "update.mode": "none",
    "vim.normalModeKeyBindings": [
        {
            "before": ["<leader>", "p", "v"],
            "commands": ["workbench.files.action.focusFilesExplorer"]
        },
        {
            "before": ["<leader>", "s", "a"],
            "commands": ["workbench.action.showCommands"]
        },
        {
            "before": ["<leader>", "s", "f"],
            "commands": ["workbench.action.quickOpen"]
        },
    ],
    "vim.visualModeKeyBindings": [
        {
            "before": ["<leader>", "g", "d"],
            "commands": ["editor.action.revealDefinition"]
        }
    ],
    "vim.leader": " ",           // optional: set leader key
    "vim.useSystemClipboard": true,
    "window.menuBarVisibility": "compact",
    "window.commandCenter": false,
    "workbench.layoutControl.enabled": false,
    "chat.commandCenter.enabled": false,
    "workbench.editor.showTabs": "none",
    "editor.minimap.enabled": false,
    "editor.fontSize": 12,
    "editor.autoClosingBrackets": "never",
    "editor.autoClosingComments": "never",
    "editor.autoClosingDelete": "never",
    "editor.autoClosingOvertype": "never",
    "editor.autoClosingQuotes": "never",
    "vim.smartRelativeLine": true,
    "editor.acceptSuggestionOnFocusChange": false,
    "workbench.activityBar.location": "hidden",
}
'''

'''
[
    {
        "key": "h",
        "command": "list.collapse",
        "when": "explorerViewletVisible && !inputFocus"
    },
    {
        "key": "l",
        "command": "list.expand",
        "when": "explorerViewletVisible && !inputFocus && explorerResourceIsFolder"
    },
    {
        "key": "j",
        "command": "list.focusDown",
        "when": "explorerViewletVisible && !inputFocus"
    },
    {
        "key": "k",
        "command": "list.focusUp",
        "when": "explorerViewletVisible && !inputFocus"
    },
    {
        "key": "l",
        "command": "explorer.openAndPassFocus",
        "when": "explorerViewletVisible && !inputFocus && explorerResourceIsFile"
    },
    {
        "key": "a",
        "command": "explorer.newFile", 
        "when": "explorerViewletFocus && !inputFocus" 
    },
    {
        "key": "w",
        "command": "workbench.action.focusActiveEditorGroup",
        "when": "explorerViewletFocus"
    },
    {
        "key": "ctrl+t",
        "command": "workbench.action.terminal.toggleTerminal",
        "when": "terminalIsOpen && vim.mode == 'Normal'",
    },
    {
        "key": "ctrl+t",
        "command": "workbench.action.terminal.new",
        "when": "!terminalIsOpen && !terminalFocus && vim.mode == 'Normal'",
    },
    {
        "key": "ctrl+shift+t",
        "command": "workbench.action.focusActiveEditorGroup",
        "when": "terminalIsOpen && vim.mode == 'Normal'",
    },
    {
        "key": "ctrl+alt+b",
        "command": "workbench.action.toggleActivityBarVisibility"
    },
    {
        "key": "ctrl+up",
        "command": "extension.vim_ctrl+y",
        "when": "editorTextFocus && vim.active && vim.use<C-y> && !inDebugRepl"
    },
    {
        "key": "ctrl+y",
        "command": "-extension.vim_ctrl+y",
        "when": "editorTextFocus && vim.active && vim.use<C-y> && !inDebugRepl"
    },
    {
        "key": "ctrl+y",
        "command": "acceptRenameInput",
        "when": "editorFocus && renameInputVisible && !isComposing"
    },
    {
        "key": "enter",
        "command": "-acceptRenameInput",
        "when": "editorFocus && renameInputVisible && !isComposing"
    },
    {
        "key": "ctrl+y",
        "command": "acceptSelectedCodeAction",
        "when": "codeActionMenuVisible"
    },
    {
        "key": "enter",
        "command": "-acceptSelectedCodeAction",
        "when": "codeActionMenuVisible"
    },
    {
        "key": "ctrl+y",
        "command": "acceptSelectedSuggestion",
        "when": "acceptSuggestionOnEnter && suggestWidgetHasFocusedSuggestion && suggestWidgetVisible && suggestionMakesTextEdit && textInputFocus"
    },
    {
        "key": "enter",
        "command": "-acceptSelectedSuggestion",
        "when": "acceptSuggestionOnEnter && suggestWidgetHasFocusedSuggestion && suggestWidgetVisible && suggestionMakesTextEdit && textInputFocus"
    },
    {
        "key": "ctrl+f ctrl+v",
        "command": "filesExplorer.paste",
        "when": "filesExplorerFocus && foldersViewVisible && !explorerResourceReadonly && !inputFocus"
    },
    {
        "key": "ctrl+v",
        "command": "-filesExplorer.paste",
        "when": "filesExplorerFocus && foldersViewVisible && !explorerResourceReadonly && !inputFocus"
    },
    {
        "key": "ctrl+shift+oem_102",
        "command": "workbench.actions.view.problems",
        "when": "workbench.panel.markers.view.active"
    },
    {
        "key": "ctrl+shift+m",
        "command": "-workbench.actions.view.problems",
        "when": "workbench.panel.markers.view.active"
    },
    {
        "key": "ctrl+shift+m",
        "command": "mssql.connect",
        "when": "editorTextFocus && editorLangId == 'sql'"
    },
    {
        "key": "ctrl+shift+c",
        "command": "-mssql.connect",
        "when": "editorTextFocus && editorLangId == 'sql'"
    },
    {
        "key": "ctrl+shift+c",
        "command": "editor.action.clipboardCopyAction"
    },
    {
        "key": "ctrl+c",
        "command": "-editor.action.clipboardCopyAction"
    },
    {
        "key": "ctrl+shift+v",
        "command": "extension.vim_ctrl+v",
        "when": "editorTextFocus && vim.active && vim.use<C-v> && !inDebugRepl"
    },
    {
        "key": "ctrl+v",
        "command": "-extension.vim_ctrl+v",
        "when": "editorTextFocus && vim.active && vim.use<C-v> && !inDebugRepl"
    },
    {
        "key": "ctrl+shift+m",
        "command": "markdown.showPreview",
        "when": "!notebookEditorFocused && editorLangId =~ /^(markdown|prompt|instructions|chatmode)$/"
    },
    {
        "key": "ctrl+shift+v",
        "command": "-markdown.showPreview",
        "when": "!notebookEditorFocused && editorLangId =~ /^(markdown|prompt|instructions|chatmode)$/"
    }
]
'''