with open("task4.dat") as f:
    File = f.readlines()
    games = []
    for line in File:
        games.append(map(int,line.strip().split()))

    games = games[1:]

# a dictionary of each square and which square(s) led to that square
# -> E.g. 8: set(3,5,6) means there's steps made from square 3,5,6 to 8
destinationFrom = dict(zip(xrange(1,101), [set() for i in xrange(100)]))

for game in games:
    player1 = game[::2]
    player2 = game[1::2]
    for i in xrange(1,len(player2)):
        destinationFrom[player1[i]].add(player1[i-1])
        
    for i in xrange(1,len(player2)):
        destinationFrom[player2[i]].add(player2[i-1])

potentialActiveSquares = []
for key in destinationFrom:
    if len(destinationFrom[key]) == 0:
        potentialActiveSquares.append(key)

# finding the snakes and ladders (jumps)
jumps = []
uncertain = []

def inRange(i, array):
    # returns all elements in the range of i+6
    toReturn = []
    for element in array:
        if element > i and element <= i+6:
            toReturn.append(element)
    return toReturn

def outOfRangeFrom(n,key):
    if key > 6:
        Range = range(key-6,key)
    else:
        Range = range(1,key)

    if key == 95:
        Range.append(99)
    elif key == 96:
        Range.extend([98,99])
    elif key == 97:
        Range.extend([97,98,99])
    elif key == 98:
        Range.append(99)
        
    return (n not in Range)

def elementsOutOfRange(key,l):
    l = sorted(list(l))
    array = []
    for element in l:
        if outOfRangeFrom(element, key):
            array.append(element)
    
    return array

for key in destinationFrom:
    if any([outOfRangeFrom(n,key) for n in destinationFrom[key]]):
        square = elementsOutOfRange(key,destinationFrom[key])
        possibleMatch = inRange(square[0], potentialActiveSquares)
        if len(possibleMatch) == 1:
            match = possibleMatch[0]
            jumps.append((match, key))
            potentialActiveSquares.remove(match)
        else:
            uncertain.append([key, square])

while len(uncertain)  > 0:
    element = uncertain[0]
    square = element[1][0]
    
    possibleMatch = inRange(square, potentialActiveSquares)
    
    if len(possibleMatch) == 1:
        jumps.append((possibleMatch[0],element[0]))
        uncertain.remove(element)
        potentialActiveSquares.remove(possibleMatch[0])
    else:
        match = inRange(element[1][-1], potentialActiveSquares)
        if len(match) == 1:
            jumps.append((match[0],element[0]))
            uncertain.remove(element)
            potentialActiveSquares.remove(match[0])
        else:
            uncertain.remove(element)
            uncertain.append(element)

ladder = []
snakes = []
for pair in jumps:
    start = pair[0]
    end = pair[1]
    if start < end:
        ladder.append(pair)
    else:
        snakes.append(pair)


ladder = sorted(ladder)
snakes = sorted(snakes)
ladderLen = str(len(ladder))
snakesLen = str(len(snakes))

print "Found "+ladderLen +" Ladders (total "+ladderLen+"):"
for pair in ladder:
    print pair[0],"to", pair[1]

print

print "Found "+snakesLen +" Ladders (total "+snakesLen+"):"
for pair in snakes:
    print pair[0],"to", pair[1]
