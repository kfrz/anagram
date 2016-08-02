# Anagram API

## Try it Out! 
I have deployed a public API accessible on Heroku at the following URL: `https://anagram-kf.herokuapp.com/`

You can try it out immediately like so:

`$ curl https://anagram-kf.herokuapp.com/words`

This will `GET` all of the words in the current corpus. 

## Local Installation 

You'll need an unix-like system and Docker with [Docker Compose](https://docs.docker.com/compose/) installed. 

I've only tested this on Debian Jessie but it's safe to say it'll run on any system that supports Docker. YMMV.

Simply clone this repository:

`$ git clone https://gitlab.com/kfrz/anagram.git` or `$ git clone https://github.com/kfrz/anagram.git`

Change into the repository directory:

`$ cd anagram`

Rename `.anagram.env.example` to `.anagram.env` - following best practice I've kept important environment variables out of the repository.

`$ mv .anagram.env.example .anagram.env`

Start the docker container:

`$ docker-compose up`

The app should successfully start and can be accessed at `http://localhost:3000/`

If this doesn't work, feel free to open an issue or fix it and submit a pull request! 

## Example API Usage 
The project should respond on the following endpoints:

- `POST /words.json`: Takes a JSON array of English-language words and adds them to the corpus.
- `GET /anagrams/:word.json?number_of_results=5`:
  - Returns a JSON array of English-language words that are anagrams of the word passed in the URL.
  - Respects a query param `?number_of_results` that indicates the maximum number of results to return. 

- `DELETE /words/:word.json`: Deletes a single word from the corpus.
- `DELETE /anagrams/:word.json` Use to delete all of that word's anagrams.
- `DELETE /words.json`: Deletes all contents of the corpus.
- `GET /words/stats.json`: Returns a count of words in the corpus, and min/max/median/average word length.
- `GET /anagrams/top.json`: Returns the words with the highest anagram count.
- `GET /anagrams/:size.json`: Returns a list of all anagram groups of size >= :size.

All data is expected to be passed as JSON. 

All words are anagrams of themselves. 

### Example

Using CURL and assuming the default port of localhost:3000

```{bash}
# Adding words to the corpus
$ curl -i -X POST localhost:3000/words -d words='["read", "dear", "dare"]'
HTTP/1.1 201 Created
...

# Fetching anagrams
$ curl -i http//localhost:3000/anagrams/read
HTTP/1.1 200 OK
...
{
  "anagrams": [
    "dear",
    "dare"
  ]
}


# Specifying maximum number of anagrams
$ curl -i http://localhost:3000/anagrams/read?limit=1
HTTP/1.1 200 OK
...
{
  "anagrams": [
    "dare"
  ]
}


# Deleting a single word from corpus
$ curl -i -X DELETE http://localhost:3000/words/read
HTTP/1.1 200 OK
...

# Deleting a single word from corpus, and all of its anagrams
$ curl -i -X DELETE http://localhost:3000/anagrams/read
HTTP/1.1 200 OK
...

# Deleting all words in corpus
$ curl -i -X DELETE http://localhost:3000/words
HTTP/1.1 204 No Content
...

# Getting stats about words in corpus
$ curl -i http://localhost:3000/words/stats
HTTP/1.1 200 OK
...
{
  "stats": {
    "count": 23901,
    "min": 2,
    "max": 30,
    "median": 6,
    "average": 8 
  }
}

# Getting the word with the highest anagram count
$ curl -i http://localhost:3000/anagrams/top.json
HTTP/1.1 200 OK
...
{
  "matriculate": 32
}

# Getting all anagram groups with size of 4
$ curl -i http://localhost:3000/anagrams/4
HTTP/1.1 200 OK
...
{
  "anagrams": {
    "ader": [
      "dare",
      "dear",
      "read"
    ],
    "desu": [
      "dues",
      "sued",
      "used"
    ],
    "aest": [
      "east",
      "eats",
      "sate",
      "seat",
      "teas"
    ]
  }
}
```

## Implementation details

Upon inspection and pondering of the action logic and structure required I decided this was a perfect use case for redis-rb. I'll wire up Grape on Rack, then get redis connected, wrap it in docker then gitlab-ci then heroku. Using redis should allow for blazing fast lookups. I'm currently just implementing a singular corpus but it could be fun to implement different sub-dictionaries or something. Tradeoffs here are maybe complexity but redis is dead simple to set up and so far I've been successful. I actually would have had to do more work to do this in pg.

Other tradeoffs for now: I'm not thinking about security or authentication. Just a simple API design with some added functionality. 

The corpus is a giant hash map of lists. Each key is an ordered combination of letters that appears in the added word, and the list is every word that matches that ordered set of letters. These lists should be alphabetically ordered. 

For each word in the dictionary input using `parse_input`, the `add_word` function will first check the corpus for an existing matching key, and if it exists, will then check for that input to be in the list already, if it is it will skip it if not it will add it to the list in alphabetical order and return. If the ordered chars do not exist it will be added as a new key and the word will be added to the list. Return and iterate through the inputs. 

Posting words to a empty or null corpus will create a new hash. 

```{ruby}
corpus == Redis.new || corpus.active
```

So basically what we need is a data store as such: 

```{ruby}
corpus = Redis.new

corpus.set key, value

corpus => { 
    "aerd" => ["dear", "read"],
    "hosw" => ["hows", "show"]
}
```

## Development
Feel free to clone/fork/download and hack away. If you've added some useful functionality or fixed a bug -- open a pull request!

Run the specs locally with `$ docker-compose exec web rspec`


