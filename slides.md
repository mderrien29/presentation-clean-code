<style>
#left {
    margin: 10px 0 15px 20px;
    text-align: center;
    float: left;
    z-index:-10;
    width:48%;
    font-size: 0.85em;
    line-height: 1.5;
}#right {
    margin: 10px 0 15px 0;
    float: right;
    text-align: center;
    z-index:-10;
    width:48%;
    font-size: 0.85em;
    line-height: 1.5;
}

#bottom-left {
    position: absolute;
    bottom: 0%;
    left: 0%;
}
#bottom-right {
    position: absolute;
    bottom: 0%;
    left: right%;
}

</style>

# Et si je codais proprement ? 
# Le Clean Code

Martial DERRIEN<br/>
Niji<br/>
2020 05 31

---

## Plan

- Introduction
- Les Variables
- Les Fonctions
- Les Commentaires
- Structurer son code
- Tests
- Code smells

---
## Introduction

![book](./assets/book.jpg)

----

## Uncle Bob

<img src="./assets/uncle_bob.jpg" alt="drawing" width="300"/>

- 2002 - Agile Software Development
- 2009 - Clean Code: A Handbook of Agile Software Craftsmanship
- 2011 - The Clean Coder: A Code Of Conduct For Professional Programmers

Note:
Quelqu'un peut-il proposer une definition d'un mauvais code ?

----

## Qu'est-ce que le "clean code" ?

![](./assets/wtf_by_minute.png)

---

## Les Variables

> You should name a variable using the same care with which you name a first-born child. - Robert C. Martin

----

## Des noms qui ont du sens

```java
int d; // elapsed times in day
```

```java
int timeElapsedInDays;
int daysSinceCreation;
int daysElapsedCreation;
int daysSinceModification;
```
<!-- .element: class="fragment" data-fragment-index="2" -->

Note:
Avez vous une meilleur idee pour nommer la variable ?

----

## Utiliser des noms prononcables

- "Humans are good at words" <!-- .element: class="fragment" data-fragment-index="3" -->

```typescript
class Customer {
  private crtTs: number;
  private csInt: number;
}
```

```typescript
class Customer {
  private creationTimestamp: number;
  private customerId: number;
}
```
<!-- .element: class="fragment" data-fragment-index="2" -->

----

## "Don't be cute"

```css
.titanic {
  float: none;
}
```

```js
var bobTheBuilder = new ApplicationBuilder(config);
```
<!-- .element: class="fragment" data-fragment-index="2" -->

```js
database.holyHandGrenade(); // reset the database
```
<!-- .element: class="fragment" data-fragment-index="3" -->

</br>

```js
const brokers = 'url.com,url2.com';

brokers.split(','); // ['url.com', 'url2.com']
```
<!-- .element: class="fragment" data-fragment-index="4" -->

```php
explode(",", $brokers);
```
<!-- .element: class="fragment" data-fragment-index="5" -->

Note:
Est-ce qu'un developpeur de php peut nous aider, Comment s'appelle la fonction qui split en PHP ?
Fin sur les variables, transitions functions

---


## Les Fonctions

> The first rule of functions is that they should be small. The second rule, is that they should be smaller than that. - Robert C. Martin

----

## Mauvais exemple

Exemple de HtmlUtils.java issu du framework 'FitNesse'

<pre><code style="font-size: 0.5em !important" data-trim data-noescape data-line-numbers="0|1|4|5|10-12|19-21" class="java">
public static String testableHtml(PageData pageData, boolean includeSuiteSetup) throws Exception {
  WikiPage wikiPage = pageData.getWikiPage();
  StringBuffer buffer = new StringBuffer();
  if (pageData.hasAttribute("Test")) {
    if (includeSuiteSetup) {
      WikiPage suiteSetup = PageCrawlerImpl.getInheritedPage(SuiteResponder.SUITE_SETUP_NAME, wikiPage);
      if (suiteSetup != null) {
        WikiPagePath pagePath = suiteSetup.getPageCrawler().getFullPath(suiteSetup);
        String pagePathName = PathParser.render(pagePath);
        buffer.append("!include -setup .")
          .append(pagePathName)
          .append("\n");
      }
    }
    WikiPage setup = PageCrawlerImpl.getInheritedPage("SetUp", wikiPage);
    if (setup != null) {
      WikiPagePath setupPath = wikiPage.getPageCrawler().getFullPath(setup);
      String setupPathName = PathParser.render(setupPath);
      buffer.append("!include -setup .")
        .append(setupPathName)
        .append("\n");
    }
  }
  buffer.append(pageData.getContent());
  if (pageData.hasAttribute("Test")) {
    WikiPage teardown = PageCrawlerImpl.getInheritedPage("TearDown", wikiPage);
    if (teardown != null) {
      WikiPagePath tearDownPath =
        wikiPage.getPageCrawler().getFullPath(teardown);
      String tearDownPathName = PathParser.render(tearDownPath);
      buffer.append("\n")
        .append("!include -teardown .")
        .append(tearDownPathName)
        .append("\n");
    }
    if (includeSuiteSetup) {
      WikiPage suiteTeardown = PageCrawlerImpl.getInheritedPage(SuiteResponder.SUITE_TEARDOWN_NAME, wikiPage);
      if (suiteTeardown != null) {
        WikiPagePath pagePath = suiteTeardown.getPageCrawler().getFullPath(suiteTeardown);
        String pagePathName = PathParser.render(pagePath);
        buffer.append("!include -teardown .")
          .append(pagePathName)
          .append("\n");
      }
    }
  }
  pageData.setContent(buffer.toString());
  return pageData.getHtml();
}
</pre></code>
<!-- .element: class="fragment" data-fragment-index="2" -->

Note:
Eurk. On va vite fais essayer de comprendre.
WTF!

----

## Smaller is better

<pre><code style="font-size: 0.5em !important" data-trim data-noescape data-line-numbers class="java">
public static String renderPageWithSetupsAndTeardowns(PageData pageData, boolean isSuite) throws Exception {
  boolean isTestPage = pageData.hasAttribute("Test");
  if (isTestPage) {
    WikiPage testPage = pageData.getWikiPage();
    StringBuffer newPageContent = new StringBuffer();
    includeSetupPages(testPage, newPageContent, isSuite);
    newPageContent.append(pageData.getContent());
    includeTeardownPages(testPage, newPageContent, isSuite);
    pageData.setContent(newPageContent.toString());
  }
  return pageData.getHtml();
}
</pre></code>


- Les fonctions ne doivent pas depasser 20 lignes !
<!-- .element: class="fragment" data-fragment-index="8" -->
- Une fonction doit se limiter a 1 ou 2 niveaux d'indentation.
<!-- .element: class="fragment" data-fragment-index="9" -->
- Un seul niveau d'abstraction par fonction
<!-- .element: class="fragment" data-fragment-index="10" -->

Note: 
Laisser quelques secondes pour comprendre.
On lit de haut en bas, comme une histoire

----

## Even smaller

> FUNCTIONS SHOULD ONLY DO ONE THING. THEY SHOULD DO IT WELL. THEY SHOULD DO IT ONLY. - Robert C. Martin
<!-- .element: class="fragment" data-fragment-index="2" -->

<pre><code style="font-size: 0.5em !important" data-trim data-noescape data-line-numbers class="java">
public static String renderPageWithSetupsAndTeardowns(PageData pageData, boolean isSuite) throws Exception {
  if (isTestPage(pageData))
    includeSetupAndTeardownPages(pageData, isSuite);
  return pageData.getHtml();
}
</pre></code>

- "Pour... Si... Alors..."
<!-- .element: class="fragment" data-fragment-index="3" -->

----

## Quelques autres regles

```typescript
function async getUser(id: string): Promise<User> {
  const user = await db.find({ user: id });
  await db.close();
  return user;
}
```

- Pas de "side effect".
<!-- .element: class="fragment" data-fragment-index="2" -->

----

## Quelques autres regles

```javascript
let numbers = [1,2,3,4,5];
const firstThreeNumbers = numbers.splice(0,3);
const lastThreeNumbers = numbers.splice(2,5);
```

```
let numbers = [1,2,3,4,5]; // 1,2,3,4,5

const firstThreeNumbers = numbers.splice(0,3); 
// firstThreeNumbers = 1,2,3
// AND numbers = 4,5

const lastThreeNumbers = numbers.splice(2,5);
// lastThreeNumbers = undefined
```
<!-- .element: class="fragment" data-fragment-index="2" -->

- Limiter les parametres "in/out"
<!-- .element: class="fragment" data-fragment-index="3" -->


----

## Quelques autres regles

```typescript
function initDb(config: Config, useHttps: boolean) {
  ...
}
```

- Limiter les parametres booleens.
<!-- .element: class="fragment" data-fragment-index="2" -->
- Limiter le nombre de parametres (2/3 maximum)
<!-- .element: class="fragment" data-fragment-index="2" -->

---

## Les Commentaires

> Don't comment bad code... Rewrite it - Robert C. Martin

- Les commentaires sont toujours un echec. L'echec d'utiliser le langage pour s'exprimer.
<!-- .element: class="fragment" data-fragment-index="2" -->
- Le code change, les commentaires peuvent donc devenir des mensonges
<!-- .element: class="fragment" data-fragment-index="3" -->
- Parfois, ils sont necessaires...
<!-- .element: class="fragment" data-fragment-index="4" -->

----

## Mauvais commentaires

```java
// Check if employee is eligible for full benefits
if ((employee.flags && HOURLY_FLAG) && (employee.age > 65)) 
```

```java
if (employee.isEligibleForFullBenefits())
```
<!-- .element: class="fragment" data-fragment-index="2" -->

- "This code is hard to read, i should add comments"
<!-- .element: class="fragment" data-fragment-index="3" -->
- "NO! You should clean it!"
<!-- .element: class="fragment" data-fragment-index="4" -->

----

## Autre exemple

```java
// does the module from the global list <mod> depend on the
// subsystem we are part of?
if (smodule.getDependSubSystems()
  .contains(subSysMod.getSubSystems()))
```

```java
ArrayList moduleDependees = smodule.getDependSubSystems();
String ourSubSystem = subSysMod.getSubSystem();
if (moduleDependees.contains(ourSubSystem))
```
<!-- .element: class="fragment" data-fragment-index="2" -->
----

## Bons commentaires

```java
// format matched: hh:mm:ss EEE, MMM dd, yyyy
Pattern timeMatcher = Pattern.compile("\\d*:\\d*:\\d* \\w*, \\w* \\d*, \\d*");
```

```typescript
function compareUsers(user1: User, user2: User): boolean {
  if(!user1.name || !user2.name) {
    // if no name is found, we shall use their id
    return user1.id - user2.id;
  }

  return user1.name > user2.name;
}
```
<!-- .element: class="fragment" data-fragment-index="2" -->

```typescript
// TODO 
// function to be removed when the checkout model is released
function makeVersion(): number {
  return '0.0.1';
}
```
<!-- .element: class="fragment" data-fragment-index="3" -->

---

## Solution

```
total_cents = total * 100
average_per_customer = total_cents / customer_count

track_average(average_per_customer)
```

- Item 1 <!-- .element: class="fragment" data-fragment-index="2" -->

---

## Structurer son code

> todo

---

## Tests

---

## "Code Smells"

![code_smells.jpeg](./assets/code_smells.jpeg)

---

## Split slide

<div id="right">

- You can place two graphs on a slide
- Or two columns of text
- These are all created with div elements

</div>

---

## code Slide

<pre><code data-line-numbers="3|4-5|6">import fs from 'fs';

fs.readFile('markdown.md', (content) => {
  console.log('content');
  console.log('do stuff');
  process.exit(0);
});</code></pre>

---


## Fragmented Slide

<!-- .slide: data-background="#ff0000" -->

- Item 1 <!-- .element: class="fragment" data-fragment-index="2" -->
- Item 2 <!-- .element: class="fragment" data-fragment-index="1" -->


---

## Video Slide 1

<video class="stretch" data-autoplay controls src="http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"></video>

----

<video class="stretch" data-autoplay controls src="http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"></video>

---

### Background Video (with notes)

<!-- .slide: data-background-video="http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4" data-background-video-loop -->

Note: let them choose

