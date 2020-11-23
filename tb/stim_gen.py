
import sys
import random
import math

path_to_repo= Enter a path to posit software model that you have. I used PySigmoid https://github.com/mightymercado/PySigmoid
sys.path.insert(0, path_to_repo)

import FixedPointImplementation as lib

def stim_gen(file_name, n_samples, operation, L = 32, ES= 6):
  assert operation in ['add', 'mul']

  FULL_L = 32

  lib.set_posit_env(L, ES)
  
  lines= []


  with open(file_name, 'w+') as f:
    for i in range(n_samples):
      in_0= ''
      in_1= ''
      full_res = ''
      for j in range(FULL_L/L):
        flt_0 = rand_flt(L, ES)
        flt_1 = rand_flt(L, ES)
        
        flt_0 = flt_1

        # ocassionally make inputs 0
        if (random.randint(0, 500) == 1) : flt_0 = 0.0 
        if (random.randint(0, 200) == 1) : flt_1 = 0.0 
        if (random.randint(0, 1000) == 1) : 
          flt_0 = 0.0 
          flt_1 = 0.0

        posit_0 = lib.flt_to_posit(flt_0)
        posit_1 = lib.flt_to_posit(flt_1)
        
        if   (operation == 'add'): res= lib.posit_add(posit_0, posit_1)
        elif (operation == 'mul'): res= lib.posit_mul(posit_0, posit_1)
        else: assert 0

        in_0 += format_hex(posit_0, L) 
        in_1 += format_hex(posit_1, L) 
        full_res += format_hex(res, L) 

      line= in_0 + ' ' + in_1 + ' ' + full_res + '\n'
      
      #print line
      lines.append(line)
    
    f.writelines(lines)

def format_hex(num, L):
  format_str= '{:0' + str(L/4) + 'x}'
  return format_str.format(num)

def rand_flt(L, ES):
  exp = rand_exp(L, ES, mode ='smaller_values')
  mant= rand_mant()

  return mant * (2**(exp))

def rand_exp(L, ES, mode):
  #regime_bits= math.ceil(math.log((L+2), 2))
  #full_exp_len= regime_bits + ES
  
  assert mode in ['uniform', 'smaller_values']

  if mode == 'uniform':
    max_exp = (L-2) * (2**ES)
    min_exp = -(L-1) * (2**ES)
  elif mode =='smaller_values':
    max_exp = 2 * (2**ES)
    min_exp = -2 * (2**ES)

  return random.randint(min_exp, max_exp)

def rand_mant():
  return random.uniform(1.0, 2.0)

  #print exp(x)

N_TESTS = 10000
L =8
ES= 2
operation = 'mul'


def gen_all():
  N_TESTS = 1000
  L_ES_set = [(32, 7), (16,4), (8,2)]
  operations_set = ['mul','add']
  
  for (L, ES) in L_ES_set:
    print L, ES
    for operation in operations_set:
      print operation

      stim_gen('./no_backup/stim/' + operation + '_stim_' + str(L) + '_' + str(ES) +'.txt', N_TESTS, operation,  L, ES)

gen_all()
