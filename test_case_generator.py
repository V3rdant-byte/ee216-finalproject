import random
# hyperparameters including file path
path = "./"
input_file_name = "input_gen.txt"
output_file_name = "output_gen.txt"
mode = 0  #mode=0: random input and output; mode=1: generate output using provided input txt
input_n=200 #number of input if mode=0

#initialize the input
global occupied_width
occupied_width=[0 for _ in range(14)]
if(mode==0):
    input_h = [random.randint(4, 16) for _ in range(input_n)]
    input_w = [random.randint(4, 16) for _ in range(input_n)]

else:
    with open(path+input_file_name, "r") as file:
        input_h = []
        input_w = []
        for line in file:
            input_h.append(int(line.split()[0]))
            input_w.append(int(line.split()[1]))
        input_n=len(input_h)

#initialize the output        
strike=0
output_x=[]
output_y=[]

index_y=[-1,0,8,16,25,32,42,48,59,64,76,80,96,112]
def get_id(h):
    if(h==4):
        return [10,8]
    if(h==5):
        return [8,6]
    if(h==6):
        return [6,4]
    if(h==7):
        return [4,1,2]
    if(h==8):
        return [1,2,3]
    if(h==9):
        return [3,5]
    if(h==10):
        return [5,7]
    if(h==11):
        return [7,9]
    if(h==12):
        return [9]
    if(h>=13):
        return [13,12,11] 

def compare(strip_id):
    optimal_occupied_width=200
    for id in strip_id:
        if(occupied_width[id]<optimal_occupied_width):
            optimal_id=id
            optimal_occupied_width=occupied_width[id]
    return optimal_id,optimal_occupied_width
        

for i in range(input_n):
    H=input_h[i]
    W=input_w[i]
    all_ids=get_id(H)
    optimal_id,optimal_occupied_width=compare(all_ids)
    if(optimal_occupied_width+W>128):
        strike=strike+1
        output_x.append(128)
        output_y.append(128)
    else:
        output_x.append(optimal_occupied_width)
        output_y.append(index_y[optimal_id])
        occupied_width[optimal_id]=occupied_width[optimal_id]+W
    
    

# Write the array to a text file
if(mode==0):
    with open(path+input_file_name, "w") as file:
        for i in range(input_n):
            file.write(f"{input_h[i]} {input_w[i]}\n")  # Write each element on a new line

with open(path+output_file_name, "w") as file:
    for i in range(input_n):
        file.write(f"{output_x[i]} {output_y[i]}\n")  # Write each element on a new line

with open(path+"strike.txt", "w") as file:
    file.write(f"{strike}\n")  # Write each element on a new line