from pygments.token import Token

def get_rich_theme(theme_name: str) -> dict:
    # A mapping from Pygments Token to Rich styles.
    # In a full implementation, you'd map standard Pygments styles.
    
    themes = {
        "monokai": {
            Token.Keyword: "bold #f92672",
            Token.Keyword.Namespace: "bold #f92672",
            Token.Name.Function: "bold #a6e22e",
            Token.Name.Class: "bold #a6e22e",
            Token.String: "#e6db74",
            Token.String.Doc: "dim #e6db74",
            Token.Comment: "dim #75715e",
            Token.Number: "#ae81ff",
            Token.Operator: "#f92672",
            Token.Name.Builtin: "#66d9ef",
        },
        "dracula": {
            Token.Keyword: "bold #ff79c6",
            Token.Name.Function: "bold #50fa7b",
            Token.Name.Class: "bold #8be9fd",
            Token.String: "#f1fa8c",
            Token.Comment: "dim #6272a4",
            Token.Number: "#bd93f9",
            Token.Operator: "#ff79c6",
            Token.Name.Builtin: "#8be9fd",
        }
    }
    
    return themes.get(theme_name, themes["monokai"])

