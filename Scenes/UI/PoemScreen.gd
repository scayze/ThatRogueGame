extends ColorRect

var active = false
var poems = []
var current_poem = -1
var max_poems = -1

onready var site_number = get_node("Site")
onready var page = get_node("Text")

# Called when the node enters the scene tree for the first time.


func init(count):
	current_poem = count
	max_poems = count
	visible = true
	active = true
	change_site()

func dismiss():
	active = false
	visible = false

func change_site():
	site_number.text = str(current_poem) + "/" + str(max_poems)
	page.text = poems[current_poem-1]

func _input(event):
	if active == false: return
	if event.is_action_pressed("bar_left"):
		current_poem -= 1
		current_poem = clamp(current_poem, 1, max_poems)
		change_site()
	if event.is_action_pressed("bar_right"):
		current_poem += 1
		current_poem = clamp(current_poem, 1, max_poems)
		change_site()

func _ready():
	poems.append("The flowers remained protected in the kingdom, until one day with the storm of the sun as a home run they flew out to the ether at three thousand kilometers per second, the world had lost its color and the ladies were sad. The queen decided to calm the people by cutting off the skin of the lats, they opened like petals.")
	poems.append("I am stronger when red, with clenched teeth, dizzy and nervous change the fear of what the flowers do when they fall by the wind they tickle with their fine and sweet petals through a sinuous hangover that splashes orange and violet tones while The sun goes out and is hidden behind a blanket of water. So, my love, I will smile at you.")
	poems.append("I am excited for tomorrow, I tell the moon, that at seven o'clock Juan and his apechusques will come to repair what will come to break. It will bring shovel, scissors and tweezers, knives and shears. Hammer and drills, nails, rivets, nuts, rods and screws. In addition to all this, Juan will bring an electromagnetic field meter and a book to read.")
	poems.append("A fire of doubt is the heart that burns before the question of whether he will love me. Analyze the battle and take the strategy that if you stay stopped nine bulls will run to step on your molars, says the circus where the dancers cry and the wind go to the other side, take some ibuprofen.")
	poems.append("Lack of color, this has become an unbreakable dream that oscillates between vigil. Grabbing that from the truth and mixing it with what is, but I do not know. The flag of the night ended and I, I think I'm still here, afraid to act and without distinguishing the right from the false, because the glasses in my hand burn the same.")
	poems.append("If I write more slowly, that cup will be used to tempt me to drink it, so I take it away with a glass of wine and tobacco. The wine is white and it flashes with light.")
	poems.append("My favorite place to hide is in my imagination, in which I can be free or no one can deprive me of it, because as the wind blows it whispers the worst, because of everything to this rabble that I have as the last defense. As for whether I did it or not, I will not say, since in this one, I take the fifth one.")
	poems.append("When I'm alone, I feel that old gust of breath that my mother used to give in my face. She did it especially when I was a kid, with four or five years of age, she would tear me up. The breath came easily through the lips and brushing the lid of the teeth the room was filled with a beautiful whistle.")
	poems.append("I'm more excited when you give me that quillotro every morning that says:\nEverything is fine.\nYes.\n")
	poems.append("A wave rests strongly on the side of the boat, she makes him hesitate and on the wet wood floor you can see the sweat and jindama of the fishermen. That bug is naked, one of the fishermen told me that the worst moments were, in fact, those of a tense calm.")
	poems.append("When I think about change, a chess game is always shown in my mind, where a queen sacrifices herself to be eaten diagonally by a bishop to take that tower and let two pawns reach the edge of the arcidriche and two beautiful queens flourish . That is change.")
	poems.append("If I could invent a new color it would be the one that suffer the curtains with the augur of the sun. Between her ambivalence as old or illuminated by hope, she remains still and at night she cries, because there is a bad moon that mercilessly stares at her. And the curtain can not scream.")
	poems.append("I can hear them call, those guttural cries that reverberate through the forest like baby crying in the cathedral, traveling swiftly through a dense air with the smell of iron and salt. Still I am, while I hear the hesitation of the branches in the distance and a shad")
	poems.append("I feel wonderful when I see the ants in the yard, those in a lemniscate around two sticks to follow their path. And they come and go carrying very heavy leaves and enter the anthill and through the earth they enter through a hole they enter. At dusk they cover themselves in their cribs and sing to their children.")
	poems.append("The big boss prayed for his dinner, prayed for the boñatos and for the mushrooms, ate and ate for his pride. He swung the armchair when he was up, trotted to the kitchen, grabbed and mixed everything, put it in the oven and waited, at times he drooled, ol tormonor it sounded morphed.")
	poems.append("The warning never arrived. Neither sirens, nor alerts. The moon had spared in mercy and over a silvery glow glimpsed the red glitter so flashing in a backlight.\nThe troupe sang out of tune, in a last and cacophonous unison. Through the leaves of the cypresses the silver illuminated all of them.")