<style>
#left {
    margin: 10px 0 15px 20px;
    text-align: center;
    float: left;
    z-index:-10;
    width:48%;
    font-size: 0.85em;
    line-height: 1.5;
}

#right {
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

# A short introduction to the clean code principles

Martial DERRIEN<br/>
<img src="./assets/mansa.png" alt="mansa" width="200"/>

---

## What are we going to see :

- Introduction
- Variables
- Functions
- Comments

<br/>

## What we probably won't :

- Code Structure
- Tests
- Objects
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
Quelqu'un peut-il me dire comment reconnaitre un mauvais code ?

SOLID

The single-responsibility principle: "There should never be more than one reason for a class to change."

The open-closed principle: "Software entities ... should be open for extension, but closed for modification."

The Liskov substitution principle: "Functions that use pointers or references to base classes must be able to use objects of derived classes without knowing it."

The interface segregation principle: "Many client-specific interfaces are better than one general-purpose interface."

The dependency inversion principle: "Depend upon abstractions, not concretions."


----

## What is "clean code" ?

![](./assets/wtf_by_minute.png)



---

## Variables

> You should name a variable using the same care with which you name a first-born child. - Robert C. Martin

----

## Use names to convey meaning

```java
int d; // elapsed time in day
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
exception: on peut utiliser des noms plus courts

----

## Use pronouncable names

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


## Functions

> The first rule of functions is that they should be small. The second rule, is that they should be smaller than that. - Robert C. Martin

----

## Bad example

Example: HtmlUtils.java from framework 'FitNesse'

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


- Functions should be short, 20 lines is already a lot !
<!-- .element: class="fragment" data-fragment-index="8" -->
- Functions should have 1 (or 2) indentation level.
<!-- .element: class="fragment" data-fragment-index="9" -->
- One function = One abstraction level.
<!-- .element: class="fragment" data-fragment-index="10" -->

Note: 
Laisser quelques secondes pour comprendre.
On lit de haut en bas, comme une histoire

Abstraction Level: The amount of complexity by which a system is viewed or programmed. The higher the level, the less detail. The lower the level, the more detail.
Si je ton neveu demande comment fonctionne une voiture et que tu m'explique comment sont fabriqués les freins, tu es au mauvais niveau d'abstraction.

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

## Some other rules...

```typescript
function async getUser(id: string): Promise<User> {
  const user = await db.find({ user: id });
  await db.close();
  return user;
}
```

- Be careful with "side effects". A function should only do what the name suggests.
<!-- .element: class="fragment" data-fragment-index="2" -->


----

## Some other rules...

```javascript
let numbers = [1,2,3,4,5];
const firstThreeNumbers = numbers.splice(0,3);
const lastThreeNumbers = numbers.splice(2,5);
```

```javascript
let numbers = [1,2,3,4,5]; // 1,2,3,4,5

const firstThreeNumbers = numbers.splice(0,3); 
// firstThreeNumbers = 1,2,3
// AND numbers = 4,5

const lastThreeNumbers = numbers.splice(2,5);
// lastThreeNumbers = undefined
```
<!-- .element: class="fragment" data-fragment-index="2" -->

- Limit "in/out" parameters. Or don't use them.
<!-- .element: class="fragment" data-fragment-index="3" -->


----

## Quelques autres regles

```typescript
function initDb(config: Config, useHttps: boolean) {
  ...
}
```

- Limit booleans parameters
<!-- .element: class="fragment" data-fragment-index="2" -->
- Limit the numbers of parameters
<!-- .element: class="fragment" data-fragment-index="3" -->

---

## Les Commentaires

> Don't comment bad code... Rewrite it - Robert C. Martin

- Comments are always failure. Failure to use the coding language to express yourself.
<!-- .element: class="fragment" data-fragment-index="2" -->
- Code changes. Comments can become liabilities.
<!-- .element: class="fragment" data-fragment-index="3" -->
- Sometimes, they are still necessary... And it feels bad to use them !
<!-- .element: class="fragment" data-fragment-index="4" -->

Note: Vous faites un oral d'anglais, vous dites des mots français pour vous rattraper

----

## Bad comments

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
<!-- .element: class="fragment" data-fragment-index="3" -->

----

## Other examples

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

## Good comments

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

## Source code structure

- Separate concepts vertically
- Related code should appear vertically dense
- Declare variables close to their usage
- Dependent functions should be close 
- Similar functions should be close
- Place functions in the downward direction
- Keep lines short
- Don't use horizontal alignment
- Use white space to associate related things and dissociate weakly related
- Don't break indentation

---

## Tests

- One assert per test
- Readable
- Fast
- Independent
- Repeatable

---

## Objects & Data structure

- Hide internal structure
- Prefer data structures
- Avoid hybrid (half object and half data)
- Should be small
- Do ONE thing
- Small number of instance variables
- Base class should know nothing about their derivatives
- Better to have many functions than to pass code into a function
- Prefer non-static methods

---

## "Code Smells"

- Rigidity (The software is difficult to change)
- Fragility (The software breaks in many places due to a single change)
- Immobility (You can not reuse parts of the code in other projects)
- Needless Complexity
- Needless Repetition
- Opacity (The code is hard to read)

---

## Sources

- [buy the book](https://www.amazon.fr/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=sr_1_1?__mk_fr_FR=ÅMÅŽÕÑ&dchild=1&keywords=clean+code&qid=1622382178&sr=8-1)
- [summary by @wojteklu](https://gist.github.com/wojteklu/73c6914cc446146b8b533c0988cf8d29)

---

## Conclusion

<textarea style="width:70%; min-height:400px">
Main points:
  Variables : should be named carefully.
  Functions : should be short ! and keep it at one abstraction level.
  Comments : should not be your favourite solution.

Let's discuss : Should we enforce it ? What could we do to enforce it ?
</textarea>
