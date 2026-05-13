# README.md Template

## How to markdown like a game designer: a cheat-sheet and style-guide with examples.

`README.md` is a special markdown document that describes the default uses of the folder within which it resides. It's a helpful place to track the current state of the folder's contents and uses. Let's imagine that a pet game with a folder named: `Cat`, would contain a text-file named: `README.md`. Inside that text file would contain notes about the character design of the `Cat`.

One may use multiple markdown documents within the same folder, but only the document named `README.md` precisely, will be displayed as the default view for any devs visiting our *git host* project folders. Git hosts *(like the ever generous and open-source: [codeberg.org](https://codeberg.org/leiskoli/templates/README.md))* will use it to display **formatted text** on the folder's main page in any modern web browser.


## Markdown Syntax

### Headings

- We use headings to describe the hierarchy or structure of the subject. Headings may range from biggest `#` to smallest `######` *(in web terms: `<h1>` thru `<h6>`)*.


# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6


### Text Formatting


#### `*italic*`

- We use *italic formatting* for new *vocabulary*, dev industry *jargon*, and trailing *(Note: meta comments.)*


#### `**bold**`

- We use **bold formatting** when drawing the user's attention to the **important parts** so the user can **skim the documents quickly**.


#### `***italic + bold***`

- We use ***italic + bold formatting*** when describing *instructional statements*.


#### `Inline Code`

- We use `inline code` with single backticks surrounding the word to designate:
  - Keyboard and mouse buttons: ***Pan by dragging with:*** `Shift` + `MMB`
  - In-app menu and button navigation: ***Let's export from the main menu:*** `File` + `Export...`
  - In an sentence describing `variables`, `functions()`, `Classes`, or `var code = "snippet"`.


#### `~~Strikethru~~`

- We use ~~strikethru formatting~~ when we want to preserve a previous statement or idea, but is no longer relevant. *(Should probably leave a note as to why it's important to keep.)*


#### URL Links

Use `[link_name](url_address)` to add inline links [Kirkja Official Website](https://kirkja.org/)


### Images

Are there any ways to make this image smaller? Not with pure Markdown.

![Kirkja Logo](http://kirkja.org/favicon.png)


#### Code Block

- Start the *code block* using three backticks on a single line: ` ``` `
- Type the code on the following lines.
- End the *code block* with another three backticks on a single line: ` ``` `

```gdscript
# Add the coding language immediately after the triple backticks on the starting line.

var dog_legs: int = 4

func _ready():
  print("Our dog has ", dog_legs, " legs.")
```


### Block Quotation

We are able to block quote source material with the characters: `> ` + `Space`


#### PAGE ONE

> :sun_with_face: Far out in the uncharted backwaters of the unfashionable end of the Western Spiral arm of the Galaxy lies a small unregarded yellow sun.
>
> :earth_asia: Orbiting this at a distance of roughly ninety-eight million miles is an utterly insignificant little blue green planet whose ape-descended **life forms are so amazingly primitive that they still think digital watches are a pretty neat idea**.
>
> :money_with_wings: This planet has - or rather had - a problem, which was this: most of the people on it were unhappy for pretty much of the time. Many solutions were suggested for this problem, but most of these were largely concerned with the movements of **small green pieces of paper**, which is odd because **on the whole it wasn't the small green pieces of paper that were unhappy**.
>
> :watch: And so the problem remained; lots of the people were mean, and most of them were miserable, even the ones with digital watches.
>
> :evergreen_tree: Many were increasingly of the opinion that they'd all made a big mistake in coming down from the trees in the first place. And some said that even the trees had been a bad move, and that no one should ever have left the oceans.
>
> :coffee: And then, one Thursday, nearly two thousand years after one man had been nailed to a tree for saying how great it would be to be nice to people for a change, a girl sitting on her own in a small café in [Rickmansworth](https://en.wikipedia.org/wiki/Rickmansworth) suddenly realized what it was that had been going wrong all this time, and she finally knew how the world could be made a good and happy place. This time it was right, it would work, and no one would have to get nailed to anything.
>
> :sob: Sadly, however, before she could get to a phone to tell anyone about it, a terribly stupid catastrophe occurred, and the idea was lost for ever.
>
> :no_entry_sign: This is not her story.
>
> :whale: But it is the story of that terrible, stupid catastrophe and some of its consequences.
>
> - ***"THGTTG"***. DA. (1979)


### Lists

#### Unordered Lists

We are able to create bulleted lists by beginning each line with: `- ` + `Space`

- bool = true: **`🗹`**
- bool = false: **`🞎`**
- We use backticks around paths: `~/Pictures/Screenshots/`


#### Ordered lists

Before each new line add: `1. ` + `Space`

1. exist.
1. behave true.
1. make mistakes.
1. atone + grow.

or we may skip ahead by starting the list with a number of our choice.

38. life
1. the
1. universe
1. and
1. everything


#### Indented Lists

Indent portions of a list by typing double-spaces in front of new indentations: `Space` + `Space` + `  - ` + `Space`

- exist.
  - behave true.
    - make mistakes.
      - atone + grow.


#### Task Lists *(checklists, todo-lists)*

Task lists are more useful within repo issues and project tasks. The *git host* will read and format markdown in slightly different ways within their project management systems.

We are able to *open a task* by prefixing each line with: `- [ ] ` + `Space`
We are able to *close a task* by prefixing each line with: `- [x] ` + `Space`

- [x] exist.
- [x] behave true.
- [ ] make mistakes.
- [ ] atone + grow.


### Tables

#### Table Syntax

- Use vertical pipes **`|`** to separate table columns.
- The first row of text is displayed as table headers.
- The second row contains the column data justification syntax `---`.
- Rows 3+ are all table data cells.

| Occasion | Unicode Glyphs | ASCII Style |
| :-- | :-:  | --: |
| Justify Left: `:--` | Justify Center: `:-:` | Justify Right: `--:` |
| Alphanumeric Keys | `W` `S` `A` `D` | [W] [S] [A] [D] |
| Modifier Keys | `Shift` `Ctrl` `Alt` | [Shift] [Ctrl] [Alt] |
| Arrow Keys | `🠉` `🠋` `🠈` `🠊` | [Up] [Down] [Left] [Right] |
| There is no real way... | to merge cells together. | óverðtryggð. |


### Further Documentation

- [Markdown Guide > Basic Syntax](https://www.markdownguide.org/basic-syntax)
- [Zulip > Message formatting](https://zulip.com/help/format-your-message-using-markdown)


###### Legal Crap

MIT License

Copyright (c) 2026 Leikskóli

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
