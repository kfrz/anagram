# Anagram API
[![build status](https://gitlab.com/kfrz/anagram/badges/master/build.svg)](https://gitlab.com/kfrz/anagram/commits/master)


## Try it Out! 
I have deployed a public API accessible on Heroku at the following URL: `https://anagram-kf.herokuapp.com/`

You can try it out immediately like so:

```{bash}
$ curl -i -X POST https://anagram-kf.herokuapp.com/api/words -d words='["east","seat"]'
...
$ curl -i https://anagram-kf.herokuapp.com/api/anagrams/east
```

This will `POST` two words to the corpus which are anagrams of each other, then `GET` all of the anagrams in the corpus. 

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
- `GET /api/words`: Returns all words in corpus, sorted in alphabetical order.
- `POST /api/words`: Takes a JSON array of English-language words and adds them to the corpus.
- `GET /api/anagrams/:word?limit=5`:
  - Returns a JSON array of English-language words that are anagrams of the word passed in the URL.
  - Respects a query param `?limit` that indicates the maximum number of results to return. 

- `DELETE /api/words/:word`: Deletes a single word from the corpus, returns all other anagrams remaining with the same key.
- `DELETE /api/anagrams/:word` Use to delete a word and all of that word's anagrams.
- `DELETE /api/words`: Deletes all contents of the corpus.
- `GET /api/words/stats`: Returns a count of words in the corpus, and min/max/median/mean word length. Returns `500` if no words in corpus.
- `GET /api/anagrams`: Returns a sorted list of all anagram keys.

All data is expected to be passed as JSON. 

All words are anagrams of themselves. 

### Example

Using CURL and assuming the default port of localhost:3000

```{bash}
# Adding words to the corpus
$ curl -i -X POST localhost:3000/api/words -d words='["read", "dear", "dare"]'
HTTP/1.1 201 Created
...

# Fetching anagrams
$ curl -i http//localhost:3000/api/anagrams/read
HTTP/1.1 200 OK
...
{
  "anagrams": [
    "dear",
    "dare"
  ]
}


# Specifying maximum number of anagrams
$ curl -i http://localhost:3000/api/anagrams/read?limit=1
HTTP/1.1 200 OK
...
{
  "anagrams": [
    "dare"
  ]
}


# Deleting a single word from corpus
$ curl -i -X DELETE http://localhost:3000/api/words/read
HTTP/1.1 200 OK
...

# Deleting a single word from corpus, and all of its anagrams
$ curl -i -X DELETE http://localhost:3000/api/anagrams/read
HTTP/1.1 200 OK
...

# Deleting all words in corpus
$ curl -i -X DELETE http://localhost:3000/api/words
HTTP/1.1 204 No Content
...

# Getting stats about words in corpus
$ curl -i http://localhost:3000/api/words/stats
HTTP/1.1 200 OK
...
{
  "stats": {
    "word_count": 23901,
    "min_length": 2,
    "max_length": 30,
    "median": 6,
    "mean": 8 
  }
}

# Getting the word with the highest anagram count
$ curl -i http://localhost:3000/api/anagrams/top.json
HTTP/1.1 200 OK
...
{
  "rate": 3
}
```

## Implementation details

Upon inspection and pondering of the action logic and structure required I decided this was a perfect use case for redis-rb. I'll wire up Grape on Rack, then get redis connected, wrap it in docker then gitlab-ci then heroku. Using redis should allow for blazing fast lookups. I'm currently just implementing a singular corpus but it could be fun to implement different sub-dictionaries or something. Tradeoffs here are maybe complexity but redis is dead simple to set up and so far I've been successful. I actually would have had to do more work to do this in pg.

Other tradeoffs for now: I'm not thinking about security or authentication. Just a simple API design with some added functionality. 
```

## Development
Feel free to clone/fork/download and hack away. If you've added some useful functionality or fixed a bug -- open a pull request!

Run the specs locally with `$ docker-compose exec web rspec`



