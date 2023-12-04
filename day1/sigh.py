
NUMBERS = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9'
}

def is_alpha_number(line, idx, r=True):
    n = None
    for k in NUMBERS.keys():
        l = len(k)
        if r:
            slc = line[idx:(idx+l)]
        else:
            slc = line[(idx - l + 1):idx+1]

        if slc == k:
            return NUMBERS[k]

    return None


def read_left(line):
    idx = 0
    num = ""
    while True:
        if idx >= len(line):
            break
        c = line[idx]
        if c in ['1', '2', '3', '4', '5', '6', '7', '8', '9']:
            return c, idx + 1
        
        alpha = is_alpha_number(line, idx)
        if alpha:
            return alpha, idx + 1

        idx += 1


def read_right(line):
    idx = len(line) - 1
    num = ""
    while True:
        if idx <= 0:
            break
        c = line[idx]
        # print(c)
        if c in ['1', '2', '3', '4', '5', '6', '7', '8', '9']:
            return c
        
        alpha = is_alpha_number(line, idx, r=False)
        if alpha:
            return alpha

        idx -= 1



def run_it():
    with open("./data/day1-1.txt") as f:
        lines = f.read().split("\n")
        nums = []
        total = 0
        for line in lines:
            l, rindex = read_left(line)
            r = read_right(line)
            if not r and l is not None:
                r = l
                print(l + r, line)
            nums.append(l + r)

        import pprint
        for num in nums:
            total += int(num)
        # pprint.pprint(nums)
        print(total)

run_it()
print(read_left("rhqrpdxthreesqhgxzknr2foursnrcfthree"))