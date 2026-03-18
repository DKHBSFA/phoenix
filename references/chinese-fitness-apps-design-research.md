# Chinese Fitness/Health/Wellness App Design Research

**Date:** 2026-03-12
**Purpose:** Analyze top Chinese fitness/health/wellness apps for UI/UX design inspiration for Phoenix app

---

## Table of Contents

1. [Chinese Design Philosophy](#1-chinese-design-philosophy)
2. [Keep (运动健身)](#2-keep-运动健身)
3. [Boohee / 薄荷健康](#3-boohee--薄荷健康)
4. [Codoon / 咕咚](#4-codoon--咕咚)
5. [Huawei Health / 华为健康](#5-huawei-health--华为健康)
6. [Xiaomi Mi Fitness / 小米运动健康](#6-xiaomi-mi-fitness--小米运动健康)
7. [火辣健身 (Hot Body Fitness)](#7-火辣健身-hot-body-fitness)
8. [悦动圈 (Yuedongyuan / Yodo Run)](#8-悦动圈-yuedongyuan--yodo-run)
9. [轻断食 (Qing Duanshi — Intermittent Fasting)](#9-轻断食-qing-duanshi--intermittent-fasting)
10. [WeChat Mini-Programs for Fitness](#10-wechat-mini-programs-for-fitness)
11. [Cross-Cutting Chinese Design Patterns](#11-cross-cutting-chinese-design-patterns)
12. [Key Takeaways for Phoenix](#12-key-takeaways-for-phoenix)

---

## 1. Chinese Design Philosophy

### High Information Density as a Feature

Chinese apps fundamentally differ from Western apps in their approach to information density. Where Western design follows "less is more," Chinese design embraces "more is more" — vibrant visuals, rich content, abundant features packed into every screen.

**Why this works in China:**
- **Linguistic efficiency:** Chinese logographic characters condense meaning into fewer glyphs, allowing more information per pixel without overwhelming native readers
- **Cultural context:** People in densely populated Chinese cities are accustomed to high sensory loads in urban environments, associating density with convenience and abundance
- **Mobile-first users:** Many Chinese users skipped the PC era entirely, going straight to smartphones — they are deeply comfortable with complex mobile interfaces
- **Collectivistic culture:** China scores among the highest on collectivism scales, so apps integrate social sharing, chat, communities, groups, and reviews into nearly every screen

### Super App Model Influence

WeChat's super-app paradigm (1.4B MAU) has shaped all Chinese app design. Users expect:
- Multiple services bundled in one app (fitness + e-commerce + social + content)
- Mini-program-style modular interfaces within apps
- Seamless payment integration (WeChat Pay, Alipay)
- Social features deeply woven into every feature, not bolted on

### Navigation Patterns

Chinese apps favor:
- **Bottom tab bars** with 4-5 tabs (thumb-friendly zone)
- **"Rudder" navigation** (舵式导航): a prominent center FAB for the core action
- **Horizontal swipeable sub-tabs** within sections
- **Pull-down refresh** with branded animations
- **Bottom sheets** for contextual actions
- **Carousel banners** at top of discovery/home screens

---

## 2. Keep (运动健身)

**Category:** All-in-one fitness platform (workouts, running, cycling, social, e-commerce)
**Users:** 300M+ registered, ~25M MAU
**Slogan:** "自律给我自由" (Self-discipline gives me freedom)

### Visual/Aesthetic Characteristics

**Color Palette:**
- **Primary:** Purple (#7B61FF range) — the defining brand color
- **Secondary:** Green — complements purple as a "neutral" pairing
- **Background:** Clean white with minimal noise
- **Accent:** High-saturation colors reserved ONLY for important icons and CTAs
- **Typography:** Avoids pure black text; uses dark gray tones. Rarely uses bold weights — the overall feeling is elegant and tranquil, more yoga-studio than gym-bro

**Design Philosophy:** Keep deliberately avoids the aggressive, high-energy aesthetic of Western fitness apps. It aims for elegance, calm sophistication — a counterintuitive choice for fitness that works because exercise in China is increasingly associated with self-improvement and mindfulness, not just physical exertion.

### Card Design

- **Rounded corners** with irregular shapes and subtle shadow effects
- Cards centered around brand purple with green, blue, and red accents — no jarring contrasts
- **Discover channel:** Card-list layouts for course categories with carousel-style horizontal scrolling within each category
- **High image density:** Cards prominently feature workout imagery, trainer photos, and video thumbnails

### Data Visualization

- Personal exercise data displayed as dashboard modules
- Step count and exercise distance with daily/weekly views
- **Leaderboards:** Step count and exercise rankings to drive social motivation
- Progress tracking with recommended courses and fitness goal tracking
- Personalized recommendation modules based on workout history

### Navigation

- Bottom tab bar (Home / Workout / Discover / Community / Profile)
- Sub-tabs within Community: Following, Curated, Circles
- Workout discovery uses card grids with horizontal scroll carousels per category

### Social Features

- Full social feed (images of meals, selfies, workout routines)
- GPS-enabled running with nearby jogger discovery and friend requests
- Community with comments, follows, circles (interest groups)
- Bright visual cues when content is being cancelled to encourage publishing instead
- Community feedback loops that increase "stickiness"

### Gamification

- Exercise streaks and consistency rewards
- Leaderboard rankings (steps, workout duration)
- Achievement badges for milestones
- Course completion certificates

### What Makes It Stand Out

1. The **purple + white** palette is instantly recognizable and feels premium
2. Restraint in color usage — high-saturation reserved for CTAs only
3. Typography and spacing create a **meditative calm** unusual for fitness apps
4. Social features are native to every screen, not a separate tab
5. Content-commerce loop: workout videos lead to equipment purchases seamlessly

### Academic Note

Research comparing Keep's Chinese and English interfaces found that **both Chinese and English speakers preferred the English version** — suggesting that even within China, the cleaner international aesthetic has appeal. This is a signal that Keep's Chinese version may carry too much information density for some users.

---

## 3. Boohee / 薄荷健康

**Category:** Healthy diet guidance, calorie counting, weight management
**Strength:** China's largest and most complete food calorie database

### Visual/Aesthetic Characteristics

**Color Palette:**
- **Primary:** Lake blue / pale cyan (湖蓝色/淡青色) — evokes freshness, health, cleanliness
- **Background:** Light, clean whites with the blue-green tint
- The overall feeling is **cool, refreshing, and green-healthy**

**Typography:** Clean, standard Chinese UI typography with good hierarchy

### Page Layout

- **Dashboard-style header:** Key metrics (calories in/out, weight, goals) displayed prominently at top
- **Static banner + card layout:** The homepage is primarily data display, not action-driven
- User-initiated actions are minimal — the design prioritizes passive data consumption
- Content lists below the dashboard for articles, recipes, fitness tips

### Navigation

- **Rudder-style navigation (舵式导航):** Bottom bar with a prominent center button for the core high-frequency action (likely food logging)
- This pattern is used because the app has several important features requiring frequent switching, with one core function elevated

### Data Visualization

- Calorie intake/burn dashboards
- Weight tracking with trend lines
- Nutritional breakdown cards
- Comprehensive food logging with the massive food database

### Unique Design Elements

- **Science-based content integration:** Articles, tips, and guidelines curated by health experts woven into the UI
- **Recipe cards:** Visual, appetizing food photography for healthy recipes
- **Minimal user-action design:** The interface assumes users primarily consume data rather than perform complex interactions — this is an interesting insight for Phoenix's biomarker/nutrition tracking screens

### What Makes It Stand Out

1. **Cool color temperature** (blue-green) creates a distinctly "health" feeling vs. the warm/energetic tones of workout apps
2. **Data-first design** — the UI is built around displaying tracked information, not driving workouts
3. **Rudder navigation** for the most-used feature — smart priority design
4. The **calorie database** is so comprehensive that the UI revolves around search and logging efficiency

---

## 4. Codoon / 咕咚

**Category:** Running/cycling GPS tracker, social fitness, gamification
**Users:** Major player in China's running community

### Visual/Aesthetic Characteristics

- Activity-oriented visual design — maps, routes, pace charts prominent
- GPS tracking with visual route maps
- Social community with running trajectory visualizations

### Gamification (Codoon's Strongest Suit)

- **Sports Coins system:** Users earn coins through steps, running, walking, daily tasks
- **Medal system:** Automatic medal awards for records and achievements
- **Leaderboards:** Running rankings among friends and community
- **Fun fitness tasks:** Gamified challenges that accelerate coin earning
- **Group competition modes:** Real-time multiplayer challenges
- The more you exercise, the more coins — creating a positive reinforcement loop

### Social Features

- "Expert Community" for sharing sports achievements
- Running trajectory creation and sharing
- Celebrity and influencer participation
- Real-time voice guidance during workouts
- Social running groups

### Data & Hardware Integration

- Professional GPS route tracking with precise trajectory
- Syncs with Codoon wristband and other wearables
- Apple Health integration
- Cloud storage for all sports data (steps, distance, calories, speed, GPS routes)

### Navigation

- Live streaming from fitness trainers accessible from main navigation
- Activity feed, articles, equipment shop, social sharing all accessible from primary nav
- Multi-functional: tracking + reading + shopping + social + streaming

### What Makes It Stand Out

1. **Gamification is the core differentiator** — the Sports Coins economy makes exercise feel like a game
2. **Real-time social competition** — not just posting results, but competing live
3. **GPS visualization** — beautiful route maps as shareable "art"
4. The app is a **mini super-app** for runners: tracking + community + shopping + streaming + competitions

---

## 5. Huawei Health / 华为健康

**Category:** Wearable companion app, health data hub
**Ecosystem:** Deeply integrated with Huawei Watch GT series, bands

### Visual/Aesthetic Characteristics

**Design Language:** Follows HarmonyOS design system — clean, structured, systematic

**Activity Ring Visualization:**
- **Three concentric rings:** Move (red/pink), Exercise (green), Stand (blue)
- Directly inspired by Apple's Activity Rings concept but adapted for Huawei's ecosystem
- Rings fill as progress accumulates throughout the day
- Calorie burn equivalences shown as playful icons (biscuits, ice cream) — a distinctly Chinese touch of gamified health info

### Recent Redesign (2024)

The June-July 2024 updates brought significant changes:
- **Health Glance:** New dashboard items for at-a-glance health status
- **Richer UI:** More detailed data presentation in main views
- **Step count + sleep summary:** Now show changes and trends, not just current values
- **Walking/running/cycling interfaces:** Completely redesigned for "immersive" experience
- **Sleep analysis:** Automatic detection of deep sleep, light sleep, REM, awake states with personalized improvement tips
- **July 2025:** AI-powered features added for predictive health insights

### Navigation

- **Four sections:** Health, Workout, Device, Profile
- Health section: Goal rainbow at top, core metrics (heart rate, sleep) below
- Workout section: Named tabs (not icons) for activities — a simplification choice
- Device and Profile: Streamlined settings

### Data Visualization

- Activity rings (tri-color concentric)
- Sleep stage charts (deep/light/REM/awake)
- Heart rate zone graphs
- Step count trend lines
- Weekly/monthly comparison views

### What Makes It Stand Out

1. **Ecosystem integration** — the app is the brain for all Huawei wearables
2. **Activity rings** provide instant visual feedback that is universally understood
3. **Immersive workout screens** redesigned in 2024 for during-exercise beauty
4. **AI health insights** (2025) — predictive, not just reactive
5. **Calorie-to-treats equivalence** — a culturally resonant gamification detail

---

## 6. Xiaomi Mi Fitness / 小米运动健康

**Category:** Wearable companion, health tracking
**Ecosystem:** Mi Band series, Xiaomi Watch

### 2024 Redesign (Global Rollout)

The September 2024 update (China got it ~2 months earlier) brought:

**Health Section:**
- Goal rainbow at top with updated design
- New small icon converting calorie burn to treat equivalents (biscuits, ice cream) — same pattern as Huawei
- Core metrics (heart rate, sleep duration) more prominent below the rainbow

**Workout Section:**
- Simplified design with **named tabs** replacing icon-only navigation
- Clearer activity categorization

**Device + Profile:**
- Streamlined settings, reduced clutter

### Design Characteristics

- Clean, MIUI-influenced design language
- White/light backgrounds with accent colors
- Information hierarchy: key metrics elevated, secondary data accessible via scroll
- Goal visualization as rainbow arc — a visual metaphor for multi-dimensional health progress

### What Makes It Stand Out

1. **Simplification trend** — the 2024 redesign actively reduced complexity, going against the Chinese "more is more" norm
2. **Treat equivalence icons** — making calorie data emotionally resonant
3. **Named tabs over icons** — choosing clarity over visual density

---

## 7. 火辣健身 (Hot Body Fitness)

**Category:** Guided workout app with video courses
**Users:** 40M+

### Visual/Aesthetic Characteristics

- High-energy visual design matching the "hot/spicy" brand name
- Prominent video content — HD workout courses with trainer demonstrations
- Over 100 free courses with companion-style teaching
- Real-time voice guidance throughout workouts

### Navigation

- Bottom navigation bar with main functional areas:
  - Training/exercise content
  - Community/UGC features
  - Personal profile

### Social Features

- User-generated content (workout photos, progress pics)
- Social sharing of workout completions
- Community challenges

### What Makes It Stand Out

1. **Video-first design** — the UI is built around presenting video content attractively
2. **Companion-style teaching** — the UI supports a "workout buddy" feeling, not just instruction
3. **Voice guidance** as a core UI element, not an add-on

---

## 8. 悦动圈 (Yuedongyuan / Yodo Run)

**Category:** Step tracking, running, fitness, cycling
**Users:** ~9.5M MAU (second in China by activity as of 2020)

### Visual/Aesthetic Characteristics

- Activity-tracking focused design
- Running-centric with various event types: daily runs, weekly challenges, monthly goals

### Navigation

- Bottom navigation similar to other Chinese fitness apps
- Training/exercise information
- Community/UGC features
- Personal profile

### Gamification

- **Weekly activities:** Daily runs, weekly runs, monthly challenges
- **Step competitions:** Social step-counting leaderboards
- **Event-based motivation:** Structured challenges to maintain engagement

### What Makes It Stand Out

1. **Challenge/event structure** keeps users coming back for time-limited goals
2. **Step-tracking social competition** — simple but effective gamification
3. High user activity rates relative to install base

---

## 9. 轻断食 (Qing Duanshi — Intermittent Fasting)

**Category:** Intermittent fasting tracker, meal planning, wellness
**Relevance to Phoenix:** Direct competitor concept for fasting feature

### Features & UI Patterns

**Fasting Plans:**
- Customizable schedules: 16:8, 5:2, alternate-day fasting
- User-friendly interface for adjusting fasting windows and meal times
- Visual fasting timer (likely circular/countdown)

**Dashboard:**
- Key metrics display: weight loss progress, fasting durations, nutrition statistics
- Built-in dashboard for at-a-glance status

**Nutrition Tracking:**
- Comprehensive meal and caloric intake tracking tools
- Integration of nutrition data with fasting windows

**Education & Community:**
- Health expert-curated articles on intermittent fasting
- Community features: share experiences, discussions, mutual support
- Tips and guidelines integrated into the tracking flow

**Reminders:**
- Customizable start/end time notifications for fasting periods

### Academic Research (2025)

A JMIR study (2025) evaluated intermittent fasting apps in Chinese app stores and found significant quality variation — most apps lacked evidence-based content. This is an opportunity for Phoenix to differentiate with its research-backed protocol.

### What Makes It Stand Out

1. **Dedicated fasting tracker** with plan customization — the timer is the hero UI element
2. **Dashboard-first design** — metrics always visible
3. **Community integration** for accountability
4. Quality gap in the market — most Chinese fasting apps lack scientific rigor

---

## 10. WeChat Mini-Programs for Fitness

### Design Principles

WeChat mini-programs follow strict design guidelines that influence all fitness mini-programs:

- **Instant clarity:** Users enter and exit quickly for specific tasks — UI must be immediately understandable
- **Persistent navigation:** Users always know where they are
- **Forgiving design:** Easy undo, no destructive actions
- **Contextual help:** Tooltips for complex features
- **Recognizable icons and labels** — no abstract symbols

### Fitness Mini-Programs in Practice

**Keepland (Keep's Offline Studio):**
- Class signup and waitlist management
- WeChat notification integration for availability
- Seamless flow: browse classes -> sign up -> get notified -> attend

**SuperMonkey:**
- Pay-per-workout model (no membership)
- Post-workout surveys rating the class
- **Member rankings:** Time spent exercising vs. other members
- Links to class photo galleries
- Mini Program notifications for engagement

### O2O (Online-to-Offline) Pattern

Chinese fitness mini-programs serve as bridges between digital and physical:
- Restaurant bookings to fitness appointments
- Digital convenience + physical experience
- Urban tech-savvy user expectation: everything bookable via phone

### What Makes Them Stand Out

1. **Lightweight, task-focused UI** — opposite of the super-app density
2. **WeChat notification integration** as a design element (users already live in WeChat)
3. **Post-activity engagement:** surveys, rankings, photos keep users connected after the workout ends
4. **Pay-per-use model** reflected in simple, transaction-focused UI

---

## 11. Cross-Cutting Chinese Design Patterns

### Patterns Observed Across Multiple Apps

| Pattern | Description | Apps Using It |
|---------|-------------|---------------|
| **Bottom tab bar (4-5 tabs)** | Standard navigation, thumb-zone friendly | Keep, Boohee, Codoon, all |
| **Rudder navigation** | Elevated center FAB for core action | Boohee, some others |
| **Dashboard headers** | Key metrics at top of home screen | Boohee, Huawei, Xiaomi, Keep |
| **Card-list with carousel** | Horizontal scroll within vertical scroll | Keep, Boohee |
| **Activity rings** | Concentric circles for multi-metric progress | Huawei, Xiaomi |
| **Social feed integration** | Community/UGC woven into main flow, not separate app | Keep, Codoon, 火辣健身, 悦动圈 |
| **Leaderboards** | Step/exercise rankings among friends | Keep, Codoon, 悦动圈, SuperMonkey |
| **Sports Coins / reward economy** | Earn virtual currency through exercise | Codoon, 悦动圈 |
| **Calorie-to-treats equivalence** | Show burn as food items (ice cream, biscuits) | Huawei, Xiaomi |
| **Named tabs over icons** | Text labels for clarity in 2024 redesigns | Xiaomi, Huawei |
| **Carousel banners** | Top-of-screen promotional/content carousels | Keep, Boohee |
| **Voice guidance** | Real-time audio coaching during workouts | Codoon, 火辣健身 |
| **Goal rainbow/arc** | Multi-metric progress as arc visualization | Xiaomi, Huawei |

### Color Trends in Chinese Fitness Apps

| App | Primary Color | Feeling |
|-----|---------------|---------|
| Keep | Purple (#7B61FF range) | Elegant, disciplined, premium |
| Boohee | Lake blue / pale cyan | Fresh, healthy, clean |
| Codoon | Orange/warm tones | Energetic, active, social |
| Huawei Health | Blue/teal (HarmonyOS) | Systematic, trustworthy |
| Xiaomi Mi Fitness | MIUI accent colors | Clean, accessible |
| 火辣健身 | Red/warm (implied by name) | Energetic, intense |

### Typography Patterns

- Avoid pure black (#000000) — use dark gray for body text
- Bold weights used sparingly — reserved for headlines and key metrics
- Chinese characters allow higher information density in same space as Latin text
- Numbers displayed large and prominent for metric-heavy screens (calories, steps, weight)

### Animation & Interaction

- Pull-down refresh with branded animations
- Smooth transitions between tabs
- Activity ring fill animations (Huawei, Xiaomi)
- Workout timer animations (countdown, progress circles)
- Achievement popup animations for gamification moments

### Data Visualization Styles

- **Concentric rings:** Multi-metric daily progress (Huawei, Xiaomi — inspired by Apple but widely adopted)
- **Line charts:** Weight, heart rate, sleep trends over time
- **Bar charts:** Weekly/monthly workout volume
- **Circular timers:** Fasting countdown, workout rest timers
- **Route maps:** GPS running paths as shareable visual content
- **Progress arcs:** Goal completion as partial circles/rainbows
- **Stat cards:** Compact metric cards with icon + number + label + trend arrow

---

## 12. Key Takeaways for Phoenix

### Design Patterns to Adopt

1. **Dashboard-first home screen** — key metrics (next workout, fasting status, biomarkers) immediately visible, like Boohee and Huawei Health
2. **Activity rings or progress arcs** — multi-metric daily progress visualization (workout + fasting + conditioning)
3. **Calm, premium color palette** — Keep's approach of elegant restraint (purple + white, no visual noise) aligns with Phoenix's "immortality through discipline" philosophy
4. **Rudder navigation** for the most-used action (start workout? log fast?)
5. **Card-based content layout** with rounded corners, subtle shadows, horizontal carousels for workout categories
6. **Gamification layer:** Achievement medals, streaks, but NOT a coin economy (Phoenix is not about commerce)
7. **Voice guidance** as a core workout feature, not optional
8. **Named tabs** over icon-only navigation for clarity

### Design Patterns to Avoid

1. **Super-app bloat** — Keep/Codoon bundle e-commerce, streaming, articles. Phoenix should stay focused
2. **Excessive social features** — Phoenix is a personal protocol tool, not a social network
3. **High information density everywhere** — adopt Chinese data-richness for dashboards/tracking, but keep workout execution screens clean and focused
4. **Carousel banners** — these are for content/ad platforms, not a protocol-driven app

### Unique Opportunities

1. **Fasting tracker quality gap** — Chinese fasting apps lack scientific rigor (JMIR 2025 study). Phoenix's evidence-based protocol is a differentiator
2. **Biomarker visualization** — no Chinese fitness app does PhenoAge or comprehensive biomarker tracking well. This is white space
3. **Integrated protocol** — most Chinese apps are single-purpose (workout OR diet OR fasting). Phoenix's 3-pillar integration (training + conditioning + nutrition) has no direct Chinese competitor
4. **Dark mode as premium** — Chinese apps are predominantly light-mode; a well-executed dark theme would feel distinctive and premium
5. **Meditation/conditioning** — an underserved category in Chinese fitness apps, mostly handled by separate meditation apps

### Specific UI Elements Worth Studying

- Keep's **purple + white + sparse accent** color strategy
- Boohee's **rudder navigation** for food logging
- Huawei's **three-ring activity visualization**
- Codoon's **medal/achievement popup** design
- Xiaomi's **goal rainbow arc** as a multi-metric summary
- SuperMonkey mini-program's **post-workout engagement** (survey + ranking + photos)
- The universal **calorie-to-treats equivalence** icon pattern (emotionally resonant data)

---

## Sources

- [Top 5 Fitness Apps in China — Marketing to China](https://marketingtochina.com/sport-brands-should-be-attentive-to-these-top-fitness-apps-for-marketing/)
- [Top 7 Fitness Apps in China — TechNode](https://technode.com/2017/06/12/top-7-fitness-apps-in-china/)
- [Chinese App Design: Why Complexity Wins — Medium](https://medium.com/@blogmadura/chinese-app-design-why-complexity-wins-in-the-chinese-digital-landscape-4699ea3527fb)
- [UX Design in China vs. United States — Medium](https://vdelacou.medium.com/ux-design-in-china-vs-united-states-88b814aa83e8)
- [The UX Design of Chinese and Western Apps — PALO IT](https://www.palo-it.com/en/blog/the-ux-design-of-chinese-and-western-apps-why-are-they-so-different)
- [Bridging the Cultural UX Divide: Why China's Approach Matters](https://digitalcreative.cn/blog/how-china-ux-is-different)
- [Chinese App Design Patterns — UI Sources](https://uisources.com/chinese-apps)
- [A Few UI Differences Between Chinese and English Apps — UX Collective](https://uxdesign.cc/a-few-ui-differences-between-chinese-and-english-apps-e72400bb08da)
- [Keep: The App Dominating China's Fitness Market — Daxue Consulting](https://daxueconsulting.com/keep-fitness-app/)
- [Keep (app) — Wikipedia](https://en.wikipedia.org/wiki/Keep_(app))
- [How KEEP Stands Out as a Social Fitness App in China — Medium](https://medium.com/inv-asia/how-keep-stands-out-as-a-social-fitness-app-in-china-ce38571fd400)
- [KEEP Fit Worldwide: Cultural Adaptations of the UI — Springer](https://link.springer.com/chapter/10.1007/978-3-031-05434-1_6)
- [Keep UI Design Analysis — Woshipm (人人都是产品经理)](https://www.woshipm.com/pd/2598424.html)
- [Keep Design Highlights for UI Designers — Tencent Cloud](https://cloud.tencent.com.cn/developer/article/2008833)
- [Boohee Product Analysis — Zhihu](https://zhuanlan.zhihu.com/p/539184332)
- [Boohee Software Review — CSDN](https://blog.csdn.net/2303_77434440/article/details/144005506)
- [Health App Design Analysis — Woshipm](https://www.woshipm.com/pd/4951878.html)
- [Keep/火辣健身/悦动圈 Competitive Analysis — Jianshu](https://www.jianshu.com/p/21613a4ad96d)
- [Top 5 Fitness Apps in China — Medium](https://medium.com/act-news/the-top-5-fitness-apps-in-china-2435fdd376e6)
- [New Xiaomi Mi Fitness App Design — NotebookCheck](https://www.notebookcheck.net/New-Xiaomi-Mi-Fitness-app-design-rolling-out-to-users-globally.893866.0.html)
- [Huawei Health June 2024 Update — Huawei Central](https://www.huaweicentral.com/huawei-health-app-gets-new-enhancements-via-june-2024-update/)
- [Huawei Health July 2025 AI Update — HuaweiUpdate](https://www.huaweiupdate.com/huawei-health-update/)
- [HUAWEI Health Activity Rings — Huawei Support](https://consumer.huawei.com/en/support/content/en-us15956081/)
- [Evaluation of Mobile Intermittent Fasting Apps in Chinese App Stores — JMIR (2025)](https://mhealth.jmir.org/2025/1/e66339)
- [Best Design Practices for WeChat Mini Programs — AppInChina](https://appinchina.co/services/design-practices-for-wechat-mini-programs/)
- [China's Fitness Industry Goes Pay-Per-Workout via Mini Programs — KrASIA](https://kr-asia.com/chinas-fitness-industry-goes-pay-per-workout-via-mini-programs)
- [WeChat Mini Program UX Design Principles — Digital Creative](https://digitalcreative.cn/blog/wechat-mini-program-ux-design-best-practices)
- [How Chinese Gyms Use WeChat — WalkTheChat](https://walkthechat.com/how-chinese-gyms-use-wechat-to-make-sure-you-workout/)
- [WeChat Mini Program UI for Fitness Data Tracking — Figma Community](https://www.figma.com/community/file/1526059566626678518/wechat-mini-program-ui-design-for-mobile-sports-fitness-data-tracking)
- [Influence of Fitness Apps on Chinese Young Adults — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11949350/)
