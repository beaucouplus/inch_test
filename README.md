I spent quite some time on this test as I have never worked with historical values and had to find a way to make it work.

I read a lot and decided to go for another table that contains all the profile values.

Getting step 1 to work was quite easy and I decided to use some nice active record methods (upsert_all !) to handle it.

On step 2, I met some difficulties because I wanted my algorithm to stay as efficient as possible. It's probably not as efficient as it should be, but I think I've managed to find some ways to limit n + 1 queries. 

One point that proved difficult was how to minimize the number of queries when asking for "matching previous records".

Also, I didn't create anything else than a lib to handle the import, but I would have created a worker to offload the work if used in real conditions.

I didn't have time to test the "row" class but the test from its parent class should be enough to make sure it works as expected.

I hope my specs are relevant and that you find my work readable.

I wish you a good week,
Maxime
