# Heading: 
    # This script is a spell corrector to correct typos in email domains. 
    # Multiple approaches have been implemented including phonetics algorithm 
    # with functions like soundex, nysiis, metaphone, and Levenshtein Distance
    # algorithm with function SequenceMatcher. 

# Dependencies: Python 2.7
# Assumptions: I assume that the typo includes not only misspelling alphabet
# like "gamil",'yahool', but also numbers or even special characters like
# "outl00k","e#change". I combined both algorithms because phonetics algorithms have
# higher accuracy but only compare alphabetic characters while Levenshtein Distance 
# algorithm compares all sorts of characters but has lower accuracy. The combination 
# has demonstrated an accuracy as high as 90%. 

# Silvia Lu, sl6149@nyu.edu, 2018/7/13

# 0. Initialization
domain = ['gmail','outlook','yahoo','hotmail','icloud','exchange','qq','inbox','aol','live'] 
# Initialize a list with correct domain names that most Animoto users use. It can be automatically
# updated with a python crawler extracting the domain names from the email addresses. It can also 
# be manually updated to accomodate our needs. 

# 1. Implement the Levenshtein Distance algorithm. 
    # Levenshtein Distance algorithm calculates the similarity between two strings 
    # by measuring the distance between them. Distance refers to the number of deletions,
    # insertions, or substitutions required to transform one string to another. For example, 
    # the distance between 'test' and 'test' is 0 since no transformations are needed. The 
    # distance between 'test' and 'tent' is 1 because one substitution will do the transformation.
    # It has been tested with great realibiltiy and validity and has been widely used in 
    # spell checking, speech recognition, etc. 

    #1.1 Import the function, transform the similarity into ratio for easier comparison, and round 
    # to three decimal places. 
from difflib import SequenceMatcher 
def similar(a, b): 
    return round(SequenceMatcher(None, a, b).ratio(),3) 


    # 1.2 Set the threshold for acceptance. The threshold to determine Whether we recognize a typo as 
    # a misspell or an irrelevant word depends on the length of the domain. If the length is smaller 
    # than or equal to 4('qq','aol','live',etc.), we only accept typos with one misspelling. 
    # If the length of the domain is longer than 4, our tolerance level will be lower accepting 
    # typos with two misspellings. 
def threshold(a):
    if len(a) <= 4:
        t = 1.0 - 1.0/len(a)
    else:
        t = 1.0 - 2.0/len(a)
    return round(t,3) 


    # 1.3 Implement the algorithm. The idea is to compare the user input with every domain in the 
    # domain list and collect the similairty ratio numbers. If the highest similarity ratio number 
    # is higher than the threshold, we output the corrected domain name. If not, the procedure will
    # output the original input and ask for manual check. 
def correction(a): 
    a = a.lower() #convert the user input into lowercase for easier comparison.
    ratio = []
    for i in domain: 
        r = similar(a,i)
        ratio += [r]
    index = ratio.index(max(ratio))
    if max(ratio) >= threshold(a): 
        return domain[index]
    else:
        return a + " doesn't match any existing record. Manual check in need."

# 2. Implement the Phonetic algorithm. 
    # The idea of Phonetic Algorithm is to index words by their pronunciations. The logic is that words 
    # that sound similar are more likely to be the same words. It is widely used for misspelling check 
    # and search functions. There are multiple algorithms including metaphone, soundex, and nysiis with
    # slightly different algorithms. My approach is to use them all to compare strings. If any of the 
    # three algorithms decide it's a match, it is highly possible that the two words are the same. 

import phonetics as ph #import the package
def compare(a,b):
    a = a.lower() # convert all words to lower case for easier comparison. 
    b = b.lower()
    m = ph.metaphone(a)==ph.metaphone(b) # compare strings using metaphone
    s = ph.soundex(a)==ph.soundex(b) # compare strings using soundex
    n = ph.nysiis(a)==ph.nysiis(b) # compare strings using nysiis
    return m + s + n 
    # The output is a number ranging from 0 to 3. If it's 0, it means neigher of the algorithms decide
    # the two words match. If it is greater than 0, it means at least one algorithm decides the two 
    # words match. I tested those functions comparing "gamil" and "gmail", "yahoo" and "yahool", and
    # "yahoo" and "yahok", found there are inconsistencies between these three. So I decided to use them
    # all to increase the accuracy. 


# 3. Combine both algorithms. 
    # I decided to test the phonetic algorithm first because it is more accurate. If it is a match 
    # then output the corrected domain name. If not, the Levenshtein algorithm will be used for a 
    # double check. Also, if the user input includes any non-alphabetic characters like 0-9 or %$*, 
    # the user input will only be examined by the Levenshtein algorithm. 

def SpellCorrector(a):
    try: 
        templist = []
        for i in domain:
            temp = compare(a,i)
            templist += [temp]
        index = templist.index(max(templist))
        if max(templist) > 0:
            return domain[index]
        else: 
            return correction(a)
    except IndexError:
        return correction(a)

# 4. Test the accuracy of the SpellCorrector
    # To test the accuracy of my SpellCorrector, I generated two lists containing misspelling email domain 
    # and correct ones. There are 30 in each list corresponding to each. The idea is to compare the correct
    # answer with the output of the SpellCorrector and calculate the accuracy rate. 

wrong = ['giaml','gimal','yahooooool','yahok','yah0O','gmaLi','Gamil','gmaill','gm@il','outl0ok','outlok','hotmial',
         'h0tmail','homali','icIoud','lcIoud','exchang','echange','qp','pp','inbac','inb0x','lnbox','aoi',
        'a0l','@ol','liue','llve','lve','1lve']
correct = ['gmail','gmail','yahoo','yahoo','yahoo','gmail','gmail','gmail','gmail','outlook','outlook','hotmail',
          'hotmail','hotmail','icloud','icloud','exchange','exchange','qq','qq','inbox','inbox','inbox',
          'aol','aol','aol','live','live','live','live']

    # For each word in the list, I will print the misspelling word, the correct answer, the output of
    # the SpellCorrector and a True/False statement indicating whether it's an accurate catch. It
    # will look like: giaml gmail gmail True
                    # @ol   aol   aol   True 
    # I will also calculate the number of correct matches and the accuracy rate in percent. 
def AccuracyTest(wrong):
    s = 0
    for i in wrong:
        answer = correct[wrong.index(i)]
        predicted = SpellCorrector(i)
        s += (answer == predicted)
        print i,answer,predicted,answer == predicted
    total = len(wrong)
    ratio = round(s*1.0/(len(wrong)),2)
    print "SpellCorrector passed {} out of {} tests and the accuracy rate is {}%.".format(str(s),str(total),str(ratio*100))

AccuracyTest(wrong)
# If you run this line, the output will include 30 lines of 
    #giaml gmail gmail True
    #@ol   aol   aol   True
    # ...
    # ...
# The last line will be: 
# "SpellCorrector passed 27 out of 30 tests and the accuracy rate is 90.0%." 

# Conclusion: The accuracy rate depends heavily on what you use to test the model. Also, the model will
# be more accurate if we make adjustments to the model according to the characteristics of the real user 
# typos. This model works the best on typos that include alphabets, numbers and special characters with 
# relatively short string comparison, specifically email domain name. 
# However, if the user typos have some sort of pattern, this model should be modified. 

