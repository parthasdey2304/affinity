#!/usr/bin/env bash
# =============================================================================
#  AFFINITY — WEBSITE BUILD ROADMAP & STRUCTURED AI PROMPT
#  File     : roadmap.sh
#  Purpose  : Canonical specification for the Affinity documentation website.
#             Hand this file to any AI code-generation tool (Cursor, Claude,
#             Copilot Workspace, etc.) as the single source-of-truth prompt.
#  Stack    : Next.js 14 (App Router) · TypeScript · Tailwind CSS v3
#  Deploy   : Vercel (zero-config)
# =============================================================================

cat << 'PROMPT'
╔══════════════════════════════════════════════════════════════════════════════╗
║                AFFINITY  —  WEBSITE BUILD SPECIFICATION                    ║
║          "The next-generation cat/bat replacement, now on the web"         ║
╚══════════════════════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 0. EXECUTIVE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Build a premium, production-ready documentation website for "Affinity" — a
Python terminal tool (pip install affinity-code-viewer) that is the ultimate
aesthetic replacement for `cat` and `bat`.

The website must mirror the UX quality of https://docs.astral.sh/uv/ but with:
  • Deep Blue (#0A0F2C → #1E3A8A) palette instead of purple/violet
  • Google Poppins font throughout
  • Glassmorphic "Apple Intelligence"-style TUI aesthetic
  • Funky box-UI cards with glassmorphism
  • All UI from: Aceternity UI, React Bits, Inspira UI, Animate UI (icons),
    and Lenis for buttery smooth scroll
  • Dynamic page routing — new MDX pages auto-appear in the sidebar with no
    reload required (SWR / React Server Components)
  • Alert/announcement toggles pinned at the very top of every page
  • Vercel-optimised, ISR + Edge Runtime where applicable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. TECH STACK — EXACT VERSIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Framework       : Next.js 14.2+  (App Router, RSC, Server Actions)
Language        : TypeScript 5.4+
Styling         : Tailwind CSS 3.4 + tailwind-merge + clsx
                  tailwindcss-animate for keyframe helpers
Animation lib 1 : Framer Motion 11 (used by Aceternity UI internally)
Animation lib 2 : Lenis 1.1 — smooth scroll provider wrapped at root layout
Animation lib 3 : Animate UI (https://animate-ui.com) — icon animations
UI lib 1        : Aceternity UI  — moving borders, background beams,
                  spotlight cards, tracing beam, text generate effect
UI lib 2        : React Bits     — animated counters, shimmer buttons,
                  glitch text, pixel trails, decrypted text
UI lib 3        : Inspira UI     — blur-in reveal, typing animation,
                  magnetic buttons, noise texture overlay
Font            : Google Fonts — Poppins (weights 300 400 500 600 700 800)
                  + JetBrains Mono for all code blocks
Icons           : Animate UI icon set + Lucide React as fallback
MDX engine      : @next/mdx + next-mdx-remote (for dynamic pages)
Syntax HL       : Shiki (VS Code grammar engine) — theme "one-dark-pro"
Search          : Pagefind (static, zero-server-cost)
Analytics       : Vercel Analytics + Vercel Speed Insights
State/fetching  : SWR 2 for client-side dynamic sidebar updates
                  React Server Components for static + ISR pages
Deployment      : Vercel (auto via GitHub integration)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 2. COLOUR SYSTEM & DESIGN TOKENS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All colours live in tailwind.config.ts under `theme.extend.colors.affinity`:

  background:
    base      : #050816    /* near-black deep space */
    surface   : #0A0F2C    /* primary dark blue */
    elevated  : #0D1B4B    /* card / panel backgrounds */
    glass     : rgba(13,27,75,0.45)  /* frosted glass panels */

  accent:
    primary   : #1E40AF    /* deep royal blue — CTA buttons, links */
    secondary : #3B82F6    /* medium electric blue — hover states */
    glow      : #60A5FA    /* light blue — glows, gradients, borders */
    highlight : #93C5FD    /* pale sky — active states, selected items */

  text:
    base      : #E2E8F0    /* near-white for body copy */
    muted     : #94A3B8    /* slate for secondary labels */
    faint     : #475569    /* very dim for metadata */
    code      : #7DD3FC    /* light blue tint for inline code */

  terminal:
    green     : #4ADE80    /* stdout success */
    red       : #F87171    /* stderr / diff removed */
    yellow    : #FACC15    /* warning / diff changed */
    cyan      : #22D3EE    /* prompt symbol */

  glass:
    border    : rgba(96,165,250,0.18)   /* blue-glow glassmorphic border */
    backdrop  : blur(16px) saturate(180%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 3. DIRECTORY STRUCTURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

affinity-web/
├── app/
│   ├── layout.tsx              # Root layout — Lenis provider, fonts, meta
│   ├── page.tsx                # Landing hero page (/)
│   ├── globals.css             # Tailwind base + custom glass/glow utilities
│   ├── not-found.tsx           # Glassmorphic 404 page
│   └── docs/
│       ├── layout.tsx          # Docs shell — sidebar + top-nav + alert bar
│       ├── page.tsx            # /docs root — auto-redirects to /docs/overview
│       └── [...slug]/
│           └── page.tsx        # Dynamic catch-all — renders any MDX doc page
│
├── content/                    # ALL documentation in MDX
│   ├── _meta.json              # Sidebar order, titles, badges (auto-scanned)
│   ├── overview.mdx
│   ├── installation.mdx
│   ├── quickstart.mdx
│   ├── configuration.mdx
│   ├── features/
│   │   ├── core-viewer.mdx
│   │   ├── watch-mode.mdx
│   │   ├── run-mode.mdx
│   │   ├── diff-viewer.mdx
│   │   ├── directory-tree.mdx
│   │   ├── stdin-piping.mdx
│   │   ├── line-focus.mdx
│   │   └── mirage-mode.mdx
│   ├── cli-reference.mdx
│   ├── themes.mdx
│   ├── contributing.mdx
│   └── changelog.mdx
│
├── components/
│   ├── layout/
│   │   ├── AlertBanner.tsx     # Top dismissible alert/announcement bar
│   │   ├── TopNav.tsx          # Fixed header with search + GitHub link
│   │   ├── Sidebar.tsx         # Dynamic sidebar — fetches _meta.json via SWR
│   │   ├── TableOfContents.tsx # Right-rail in-page headings
│   │   └── Footer.tsx
│   │
│   ├── ui/
│   │   ├── GlassCard.tsx       # Reusable glassmorphic card (Aceternity)
│   │   ├── CommandBlock.tsx    # Shiki-powered terminal code block
│   │   ├── TerminalWindow.tsx  # Fake terminal frame (box-drawing chars)
│   │   ├── FeatureGrid.tsx     # Funky card grid (React Bits shimmer)
│   │   ├── InstallTabs.tsx     # pip / source / brew tab switcher
│   │   ├── ThemeShowcase.tsx   # Interactive theme preview
│   │   ├── SearchModal.tsx     # Pagefind-powered ⌘K search
│   │   └── BadgePill.tsx       # New / Beta / Stable version badges
│   │
│   ├── hero/
│   │   ├── HeroSection.tsx     # Landing hero — Aceternity spotlight + beams
│   │   ├── AnimatedTerminal.tsx # Typewriter-style terminal demo (Inspira UI)
│   │   └── StatsBar.tsx        # GitHub stars / PyPI downloads counters
│   │
│   └── mdx/
│       ├── MDXComponents.tsx   # Custom MDX component map
│       ├── Callout.tsx         # Info / Warning / Danger callout boxes
│       ├── Steps.tsx           # Numbered step component
│       └── Tabs.tsx            # Content tab switcher
│
├── lib/
│   ├── mdx.ts                  # MDX compilation + frontmatter parsing
│   ├── nav.ts                  # Sidebar nav builder from _meta.json
│   ├── shiki.ts                # Shiki singleton for code highlighting
│   └── analytics.ts            # Vercel analytics helpers
│
├── public/
│   ├── logo.svg
│   ├── og-image.png
│   └── fonts/                  # Self-hosted Poppins fallback
│
├── styles/
│   └── glass.css               # Glass morphism utility classes
│
├── next.config.mjs
├── tailwind.config.ts
├── tsconfig.json
└── vercel.json

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 4. PAGE-BY-PAGE SPECIFICATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── 4.1  ROOT LAYOUT  (app/layout.tsx) ──────────────────────────────────────

• Import Poppins via next/font/google: weights [300,400,500,600,700,800],
  subsets ['latin'], variable '--font-poppins', display 'swap'
• Import JetBrains Mono similarly for --font-mono
• Wrap children in <LenisProvider> for global smooth scroll
• Wrap in <FramerMotionConfig reducedMotion="user">
• <AlertBanner /> rendered ABOVE everything else (z-index 9999)
• Meta: title template "Affinity | %s", OG image, Twitter card
• Add Vercel <Analytics /> and <SpeedInsights /> at root

── 4.2  ALERT BANNER  (components/layout/AlertBanner.tsx) ──────────────────

• Full-width top bar, deep blue (#1E3A8A) bg with blue-glow border-bottom
• Glass effect: backdrop-blur-sm, bg-affinity-glass
• Content fetched from /api/alerts (Next.js Route Handler reading alerts.json)
  — this makes alerts DYNAMIC — update alerts.json → no redeployment needed
• Dismiss button (×) stores dismissal in localStorage per alert id
• Animated slide-down entrance via Framer Motion AnimatePresence
• Supports types: "info" (blue) | "warning" (yellow) | "release" (green)
• Example content:
    🚀  Affinity v1.2.0 is live!  pip install --upgrade affinity-code-viewer
    [View Changelog →]
• Multiple alerts stacked vertically, each independently dismissable

── 4.3  LANDING HERO  (app/page.tsx + components/hero/) ────────────────────

SECTION A — Above the fold:
• Full-viewport hero with Aceternity <BackgroundBeams /> (deep blue variant)
• <SpotlightCard> with glassmorphic inner panel
• Large heading with React Bits <GlitchText>:
    "The IDE Experience.  In Your Terminal."
• Subheading: Poppins 400, muted slate color, max-w-lg centered
• Two CTA buttons:
    [Get Started →]   — Aceternity <MovingBorderButton> deep blue
    [View on GitHub]  — outline ghost button with Animate UI GitHub icon
• Animated install command block:
    pip install affinity-code-viewer
  React Bits <ShimmerButton> style copy button on right
• Inspira UI <BlurIn> reveal animation for the entire hero block

SECTION B — Animated Terminal Demo:
• <AnimatedTerminal> component — a fake glassmorphic TUI window
  rendered with Unicode box-drawing characters (matching Affinity's style)
• Typewriter animation cycles through key feature demos:
    1. affinity main.py           (shows syntax highlighted fibonacci code)
    2. affinity diff a.py b.py    (shows diff output)
    3. affinity watch server.js   (shows watch mode)
    4. affinity mirage .          (shows mirage TUI)
• Window chrome: stoplight dots (red/yellow/green), fake terminal title,
  blinking cursor at end of typed command
• Glass window border: 1px solid rgba(96,165,250,0.25)
• All terminal text uses JetBrains Mono, color tokens from section 2

SECTION C — Feature Grid:
• Heading: "Everything a Developer Needs"
• 3×3 glassmorphic card grid (Aceternity <HoverBorderGradient>)
• Each card: Animate UI animated icon + title + 1-line description
• Cards:
    🎨 Syntax Highlighting   — 300+ language support via Pygments
    📏 Scope Guides          — VS Code-style vertical indent markers
    ⚡ Watch Mode            — Live re-render on every file save
    🔀 Diff Viewer           — Color-coded side-by-side comparisons
    ▶  Inline Execution      — Run & view output in one command
    🌲 Directory Tree        — Beautiful `tree`-style folder view
    🔍 Smart Search          — Highlight search terms inline
    🎭 Theme Engine          — Monokai, Dracula, Nord, One Dark…
    🖥  Mirage Mode           — Full-screen terminal IDE (vim-like)

SECTION D — Install Section:
• <InstallTabs> with three tabs: PyPI | Source | Homebrew (coming soon)
• Each tab shows a styled command block with copy button
• Background: Aceternity <BackgroundGradient> deep blue mesh

SECTION E — Stats Bar:
• Framer Motion number counters animating up on scroll-into-view
    ⭐  GitHub Stars     |  📦  PyPI Downloads  |  🌐  Languages Supported
• Data fetched via SWR from /api/stats (hits GitHub + PyPI APIs, cached 1hr)

── 4.4  DOCS LAYOUT  (app/docs/layout.tsx) ─────────────────────────────────

• Three-column layout: [Sidebar 260px] [Main content flex-1] [ToC 220px]
• Sidebar and ToC are sticky, main content scrolls
• <TopNav> fixed at top (below <AlertBanner>)
• Sidebar built from _meta.json, client-side refreshed every 30s via SWR
  — When you add a new .mdx file + entry in _meta.json, sidebar updates
    without page reload (SWR revalidation)
• Active route highlighted with deep blue left border + glass bg
• Collapsible section groups with smooth Framer Motion height animation
• Mobile: sidebar becomes a slide-over drawer (Inspira UI <Sheet>)

── 4.5  DYNAMIC DOC PAGE  (app/docs/[...slug]/page.tsx) ────────────────────

• Params: slug joined as filepath → content/${slug.join('/')}.mdx
• Uses next-mdx-remote/rsc for zero-bundle RSC rendering
• generateStaticParams at build time (ISR revalidate: 60s for updates)
• MDX frontmatter schema:
    ---
    title: string
    description: string
    badge: "new" | "beta" | "stable" | undefined
    order: number
    ---
• Custom MDX component map (<MDXComponents>):
    h1-h6  → styled with Poppins, anchor links, deep blue underlines
    code   → <CommandBlock> (inline) or <TerminalWindow> (fenced)
    pre    → Shiki-highlighted with copy button
    a      → underline + hover glow
    table  → glassmorphic bordered table
    img    → Next.js <Image> with blur placeholder
    kbd    → styled keyboard key chips
    <Callout>  → Info/Warning/Danger box
    <Steps>    → Numbered step list
    <Tabs>     → Tab switcher component
• Breadcrumb trail at top of each page
• "Edit this page on GitHub" link at bottom
• Prev/Next page navigation footer

── 4.6  TOP NAV  (components/layout/TopNav.tsx) ────────────────────────────

• Glass header: backdrop-blur-xl, bg-affinity-glass, border-b blue-glow
• Left: Affinity logo (SVG) + "affinity" wordmark in Poppins 700
• Center: /docs   /features   /themes   /changelog   /contributing
  — Animated underline pill slides between items (Inspira UI)
• Right:
    [⌘K Search]  — opens <SearchModal> on click
    [GitHub ★]   — Animate UI GitHub icon + live star count
    [npm badge]  — links to PyPI page
• Scroll-aware: adds stronger backdrop-blur and border shadow on scroll

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 5. UI COMPONENT CONVENTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GLASS CARD PATTERN (use everywhere for panels/cards):
  className="
    relative rounded-xl
    bg-affinity-glass
    border border-affinity-glass-border
    backdrop-blur-xl
    shadow-[0_0_30px_rgba(30,64,175,0.15)]
    hover:shadow-[0_0_40px_rgba(96,165,250,0.25)]
    transition-all duration-300
  "

GLOW BUTTON PATTERN (primary CTA):
  className="
    px-6 py-3 rounded-lg font-semibold
    bg-gradient-to-r from-blue-700 to-blue-500
    hover:from-blue-600 hover:to-blue-400
    shadow-[0_0_20px_rgba(59,130,246,0.4)]
    hover:shadow-[0_0_30px_rgba(96,165,250,0.6)]
    transition-all duration-200
  "
  Wrap with Aceternity <MovingBorder> for extra premium feel.

TERMINAL WINDOW PATTERN:
  • Outer: glass card with dark bg (#0A0F1E)
  • Chrome bar: flex row, 3 stoplight circles + centered filename label
  • Font: JetBrains Mono 13px
  • Line numbers: dim slate color
  • Syntax tokens: use affinity terminal color tokens (section 2)
  • Horizontal scrollbar hidden, vertical scrollbar styled blue

SECTION DIVIDERS:
  • Use a subtle 1px gradient line:
      bg-gradient-to-r from-transparent via-blue-800/40 to-transparent
  • Occasionally use Aceternity <Separator> with glow variant

ICON GUIDELINES:
  • Use Animate UI's animated icons by default for all interactive elements
  • Example: <AnimateIcon icon="copy" animate="pulse" on="click" />
  • Lucide React as static fallback when animation not needed
  • All icons: size 18px, color currentColor, strokeWidth 1.5

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 6. DYNAMIC SIDEBAR SYSTEM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The sidebar is the most important dynamic feature. Here's exactly how it works:

  1. content/_meta.json defines the sidebar structure:

     {
       "overview":      { "title": "Overview",     "order": 1 },
       "installation":  { "title": "Installation", "order": 2 },
       "quickstart":    { "title": "Quickstart",   "order": 3, "badge": "new" },
       "features": {
         "title": "Features",
         "order": 4,
         "items": {
           "core-viewer":     { "title": "Core Viewer",    "order": 1 },
           "watch-mode":      { "title": "Watch Mode",     "order": 2 },
           "run-mode":        { "title": "Run Mode",       "order": 3 },
           "diff-viewer":     { "title": "Diff Viewer",    "order": 4 },
           "directory-tree":  { "title": "Directory Tree", "order": 5 },
           "stdin-piping":    { "title": "Stdin Piping",   "order": 6 },
           "line-focus":      { "title": "Line Focus",     "order": 7 },
           "mirage-mode":     { "title": "Mirage Mode",    "order": 8, "badge": "beta" }
         }
       },
       "cli-reference":  { "title": "CLI Reference",  "order": 5 },
       "themes":         { "title": "Themes",          "order": 6 },
       "contributing":   { "title": "Contributing",    "order": 7 },
       "changelog":      { "title": "Changelog",       "order": 8 }
     }

  2. Route Handler: app/api/nav/route.ts
     — Reads _meta.json at runtime (fs.readFileSync)
     — Returns JSON, cache-control: no-store (always fresh)

  3. Client Sidebar component uses SWR:
     const { data: nav } = useSWR('/api/nav', fetcher, { refreshInterval: 30000 })
     — Sidebar re-renders every 30 seconds without page reload
     — Adding a new .mdx file + _meta.json entry → appears in sidebar ~30s

  4. New page pattern for contributors:
     a. Create content/my-new-page.mdx with frontmatter
     b. Add entry to content/_meta.json
     c. Push to GitHub → Vercel auto-redeploys AND sidebar updates live

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 7. DOCUMENTATION CONTENT OUTLINE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Generate full MDX content for every page below. Refer to README.md and
Design.md in the repository for authoritative technical details.

7.1  overview.mdx
  • What is Affinity? (one para elevator pitch)
  • Why Affinity over bat/cat? (comparison table)
  • Feature highlights grid
  • Quick 30-second demo terminal animation embed

7.2  installation.mdx
  • System requirements (Python 3.8+, pip, optional: git)
  • Method 1: PyPI (recommended)
      pip install affinity-code-viewer
  • Method 2: From source (clone + ./start.sh)
  • Method 3: pipx for isolated install
  • Verifying installation: affinity --version
  • Uninstalling: ./remove.sh
  • Troubleshooting PATH issues (note about ~/.local/bin)

7.3  quickstart.mdx  [badge: new]
  • Your first affinity command
  • View a file with syntax highlighting
  • Try a theme: affinity main.py --theme dracula
  • Watch a file: affinity watch file.py
  • Diff two files: affinity diff a.py b.py
  • Launch Mirage IDE: affinity mirage .
  • Callout: "Pro Tip — create ~/.config/affinity/config.toml for defaults"

7.4  configuration.mdx
  • Config file location (~/.config/affinity/config.toml)
  • All available keys + types + defaults (table)
  • Example config.toml with annotations
  • CLI flag precedence over config file

7.5  features/core-viewer.mdx
  • How Pygments token-lexing works under the hood
  • What are scope guides? (diagram)
  • Dynamic file header explained
  • Smart line wrapping algorithm
  • Terminal mock showing fibonacci example from Design.md

7.6  features/watch-mode.mdx
  • How filesystem events are captured (watchdog)
  • Performance: debounce behavior
  • Keyboard interrupt to exit
  • Terminal mock from Design.md

7.7  features/run-mode.mdx
  • Execution sandbox (subprocess)
  • Passing arguments: --args flag
  • Exit code display
  • stdout + stderr rendering
  • Terminal mock from Design.md

7.8  features/diff-viewer.mdx
  • Unified vs side-by-side output
  • Color semantics (red=removed, green=added, yellow=changed)
  • Terminal mock from Design.md

7.9  features/directory-tree.mdx
  • Automatic directory detection
  • Unicode tree rendering
  • Hidden file filtering
  • Terminal mock from Design.md

7.10 features/stdin-piping.mdx
  • How stdin auto-detection works
  • Usage examples with grep, curl, cat
  • Language auto-detection on piped streams
  • Terminal mock from Design.md

7.11 features/line-focus.mdx
  • --line flag usage
  • Visual dimming of surrounding lines
  • Terminal mock from Design.md

7.12 features/mirage-mode.mdx  [badge: beta]
  • Full description of Mirage architecture
  • Dual-buffer system explained
  • Vim-style modal editing: NORMAL / INSERT / VISUAL
  • OSC 52 clipboard + SSH detection
  • Interactive file browser
  • Auto-backup system (.affinity.bak)
  • Keybinding reference table
  • Terminal mock from Design.md

7.13 cli-reference.mdx
  • Complete command reference table (all flags + types + defaults)
  • Generated from pyproject.toml metadata
  • Examples for every flag

7.14 themes.mdx
  • All supported themes (Monokai, Dracula, One Dark, Nord, Solarized, …)
  • Visual preview of each theme (rendered terminal mock in the page)
  • How to set default theme in config.toml
  • How to preview a theme: affinity main.py --theme <name>

7.15 contributing.mdx
  • Code of Conduct
  • Fork → branch → commit → PR workflow
  • Running tests locally
  • Coding standards (Black formatter, type hints)
  • PR checklist

7.16 changelog.mdx
  • v1.0.0 — Initial release
  • v1.1.0 — Watch mode + diff viewer
  • v1.2.0 — Mirage mode (beta) + stdin piping
  • Upcoming: v1.3.0 roadmap items

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 8. LENIS SMOOTH SCROLL SETUP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// lib/lenis.tsx  — use this exact implementation:

'use client'
import Lenis from 'lenis'
import { createContext, useContext, useEffect, useRef } from 'react'

const LenisContext = createContext<Lenis | null>(null)
export const useLenis = () => useContext(LenisContext)

export function LenisProvider({ children }: { children: React.ReactNode }) {
  const lenisRef = useRef<Lenis | null>(null)

  useEffect(() => {
    const lenis = new Lenis({
      duration: 1.2,
      easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
      orientation: 'vertical',
      smoothWheel: true,
    })
    lenisRef.current = lenis

    function raf(time: number) {
      lenis.raf(time)
      requestAnimationFrame(raf)
    }
    requestAnimationFrame(raf)

    return () => lenis.destroy()
  }, [])

  return (
    <LenisContext.Provider value={lenisRef.current}>
      {children}
    </LenisContext.Provider>
  )
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 9. GLASSMORPHISM CSS UTILITIES  (styles/glass.css)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/* Apple Intelligence-style glass panels */
.glass-panel {
  background: rgba(13, 27, 75, 0.45);
  backdrop-filter: blur(16px) saturate(180%);
  -webkit-backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid rgba(96, 165, 250, 0.18);
  border-radius: 12px;
}

.glass-panel-light {
  background: rgba(30, 58, 138, 0.25);
  backdrop-filter: blur(12px) saturate(160%);
  -webkit-backdrop-filter: blur(12px) saturate(160%);
  border: 1px solid rgba(147, 197, 253, 0.15);
  border-radius: 10px;
}

/* Blue glow card hover */
.glow-card {
  transition: box-shadow 0.3s ease, transform 0.3s ease;
}
.glow-card:hover {
  box-shadow: 0 0 40px rgba(96, 165, 250, 0.25),
              0 0 80px rgba(30, 64, 175, 0.15);
  transform: translateY(-2px);
}

/* Terminal window chrome */
.terminal-chrome {
  background: linear-gradient(135deg, #0A0F2C 0%, #0D1B4B 100%);
  border: 1px solid rgba(96, 165, 250, 0.2);
  border-radius: 10px;
  overflow: hidden;
}

/* Noise texture overlay (Inspira UI style) */
.noise-overlay::after {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,..."); /* SVG noise */
  opacity: 0.03;
  pointer-events: none;
  border-radius: inherit;
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 10. VERCEL DEPLOYMENT CONFIG  (vercel.json)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "installCommand": "npm ci",
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Frame-Options",        "value": "DENY" },
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "Referrer-Policy",        "value": "strict-origin-when-cross-origin" }
      ]
    },
    {
      "source": "/api/(.*)",
      "headers": [
        { "key": "Cache-Control", "value": "no-store" }
      ]
    }
  ],
  "rewrites": [
    { "source": "/docs", "destination": "/docs/overview" }
  ]
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 11. NEXT.JS CONFIG  (next.config.mjs)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import createMDX from '@next/mdx'
import remarkGfm from 'remark-gfm'
import rehypeSlug from 'rehype-slug'
import rehypeAutolinkHeadings from 'rehype-autolink-headings'

const withMDX = createMDX({
  options: {
    remarkPlugins: [remarkGfm],
    rehypePlugins: [rehypeSlug, rehypeAutolinkHeadings],
  },
})

/** @type {import('next').NextConfig} */
const nextConfig = {
  pageExtensions: ['ts', 'tsx', 'mdx'],
  experimental: { mdxRs: true },
  images: {
    remotePatterns: [
      { hostname: 'img.shields.io' },
      { hostname: 'avatars.githubusercontent.com' },
    ],
  },
  async redirects() {
    return [{ source: '/docs', destination: '/docs/overview', permanent: false }]
  },
}

export default withMDX(nextConfig)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 12. PACKAGE.JSON DEPENDENCIES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{
  "dependencies": {
    "next": "^14.2.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "typescript": "^5.4.0",

    "@next/mdx": "^14.2.0",
    "next-mdx-remote": "^5.0.0",
    "gray-matter": "^4.0.3",
    "remark-gfm": "^4.0.0",
    "rehype-slug": "^6.0.0",
    "rehype-autolink-headings": "^7.1.0",
    "shiki": "^1.0.0",

    "framer-motion": "^11.0.0",
    "lenis": "^1.1.0",
    "swr": "^2.2.0",

    "tailwindcss": "^3.4.0",
    "tailwind-merge": "^2.3.0",
    "clsx": "^2.1.0",
    "tailwindcss-animate": "^1.0.7",

    "lucide-react": "^0.400.0",

    "@vercel/analytics": "^1.3.0",
    "@vercel/speed-insights": "^1.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}

NOTE: Aceternity UI, React Bits, Inspira UI, and Animate UI are
      component libraries installed via their respective npx CLI tools:
        npx aceternity-ui@latest add <component>
        npx reactbits install <component>
        npx inspira-ui add <component>
        npx animate-ui@latest add <component>
      They install source files directly into components/ui/ — commit them.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 13. PERFORMANCE REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• Lighthouse Performance score ≥ 95 on docs pages
• LCP < 1.2s (Vercel Edge Network + ISR)
• No layout shift (CLS = 0) — all fonts preloaded, glass cards have fixed dims
• Shiki runs server-side only — zero JS for syntax highlighting
• Framer Motion: use LazyMotion with domAnimation subset to cut ~20kb
• Lenis: loaded only client-side with dynamic import
• Images: next/image with priority on hero, lazy elsewhere
• Code splitting: each docs page is its own RSC chunk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 14. BUILD & DEPLOY STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 1 — Scaffold:
  npx create-next-app@latest affinity-web \
    --typescript --tailwind --app --src-dir=false --import-alias="@/*"

Step 2 — Install deps:
  npm install framer-motion lenis swr next-mdx-remote gray-matter \
    remark-gfm rehype-slug rehype-autolink-headings shiki \
    tailwind-merge clsx tailwindcss-animate lucide-react \
    @vercel/analytics @vercel/speed-insights @next/mdx

Step 3 — Install component libraries:
  npx aceternity-ui@latest add background-beams spotlight moving-border \
    hover-border-gradient text-generate-effect tracing-beam
  npx reactbits install GlitchText ShimmerButton AnimatedCounter PixelTrail
  npx inspira-ui add blur-in magnetic-button typing-animation noise-texture
  npx animate-ui@latest add copy github arrow-right terminal

Step 4 — Apply design system:
  • Paste colour tokens into tailwind.config.ts
  • Add glass.css utilities
  • Set up Poppins + JetBrains Mono via next/font/google

Step 5 — Build content:
  • Create content/ directory structure
  • Add all MDX files with proper frontmatter
  • Add _meta.json

Step 6 — Wire up dynamic sidebar + API routes:
  • app/api/nav/route.ts
  • app/api/alerts/route.ts
  • app/api/stats/route.ts (GitHub + PyPI fetch, cache 1hr)

Step 7 — Deploy to Vercel:
  git init && git add . && git commit -m "init: affinity docs website"
  # Connect repo to Vercel via https://vercel.com/new
  # Zero config needed — Vercel auto-detects Next.js
  # Set env vars in Vercel dashboard if any (e.g. GITHUB_TOKEN for stats API)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 15. QUALITY CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  [ ] All pages render correctly in mobile (375px) and desktop (1440px)
  [ ] Sidebar updates within 30s when _meta.json changes (no reload)
  [ ] Alert banner dismisses and persists via localStorage
  [ ] ⌘K search opens SearchModal and returns correct results
  [ ] All terminal mock blocks use JetBrains Mono and correct color tokens
  [ ] Lenis smooth scroll works (no janky jumps)
  [ ] Animate UI icons animate on interaction
  [ ] Glassmorphic cards visible on both light-tinted and dark backgrounds
  [ ] All MDX pages render without errors (run `npm run build` to verify)
  [ ] Vercel deployment succeeds with no build warnings
  [ ] GitHub repo link in nav points to https://github.com/parthasdey2304/affinity
  [ ] PyPI badge links to https://pypi.org/project/affinity-code-viewer/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 REFERENCE LINKS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Design inspiration  : https://docs.astral.sh/uv/
  Aceternity UI       : https://ui.aceternity.com
  React Bits          : https://reactbits.dev
  Inspira UI          : https://inspira-ui.com
  Animate UI          : https://animate-ui.com
  Lenis               : https://lenis.darkroom.engineering
  Shiki               : https://shiki.style
  Poppins (Google)    : https://fonts.google.com/specimen/Poppins
  JetBrains Mono      : https://fonts.google.com/specimen/JetBrains+Mono
  Affinity repo       : https://github.com/parthasdey2304/affinity
  PyPI package        : https://pypi.org/project/affinity-code-viewer/

PROMPT

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  roadmap.sh loaded.                                        ║"
echo "║  Feed this file to Cursor / Copilot Workspace / Claude     ║"
echo "║  to scaffold the full Affinity documentation website.      ║"
echo "╚════════════════════════════════════════════════════════════╝"
