#!/usr/bin/env python
# ----------------------------------------- #
# stat.py
# ----------------------------------------- #
#
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
#
# -- read data
dfs = []
means=[]
for name in range(16):
    try:
        df=(pd.read_csv('S'+str(name+1)+'/fort.9',delim_whitespace = True,\
            names=["time","CFL","fx","fy","fpx","fpy","px","py","pp"]))
    except FileNotFoundError:
        exit('stat: fort.9 not found')
    # try:
    #     mg = pd.read_csv('fort.8',delim_whitespace = True,
    #         names=["itr","res0","res","inf"])[2:]
    # except FileNotFoundError:
    #     exit('stat: fort.8 not found')
    # try:
    #     ln = pd.read_csv('fort.10',delim_whitespace = True,
    #         names=["time","x","py"])
    # except FileNotFoundError:
    #     exit('stat: fort.10 not found')

    # -- post process signals
    df['x'] = df['fx']+df['fpx']
    # df['y'] = df['fy']+df['fpy']
    # df['p'] = df['px']+df['pp']

    # ln['cycle'] = np.floor(ln.time)
    # ln['phase'] = np.rint((ln.time-ln.cycle)*8)
    #
    # -- remove early (transient) and make late
    df.query('time > 6.', inplace=True)
    dfs.append(df)
    # ln.query('time > 5', inplace=True)
    # #
    # # -- group the lines
    # grouped = (ln.groupby(['phase','x'], as_index=False).mean() # take mean for each phase and x
    #             .groupby('phase')) # regroup by phase
    #
# -- plot PDF pages
def plot_hist(pdf,name,label):
    fig, ax = plt.subplots(figsize=(8,4))
    ax.set_xlabel(r'$t/T$', fontsize=12)
    ax.set_ylabel(label, fontsize=12)
    ax.ticklabel_format(axis='y',style='sci',scilimits=(0,3))
    for i in enumerate(dfs):
        c = (i[0]+1)*64
        ax.plot(i[1]['time'], i[1][name]*((c+c/11)/(2*c+c/11)), label='c = {}'.format(c))
        late = i[1].query('time > 8')
        txt = 'mean='+str(round(late[name].mean()*(i[0]+1)*64/4,4))
        print('c = '+str((i[0]+1)*64)+'     {} = '.format(name)+str(round(late[name].mean()*(i[0]+1)*64/4,4)))
        ax.text(0.8*i[1]['time'].max(),late[name].mean(),txt,fontsize=12)
    ax.legend(loc='upper left')
    pdf.savefig()

def plot_means(pdf,name,label):
    fig, ax = plt.subplots(figsize=(8,4))
    ax.set_xlabel(r'$c$', fontsize=12)
    ax.set_ylabel(label, fontsize=12)
    ax.ticklabel_format(axis='y',style='sci',scilimits=(0,3))
    for i in enumerate(dfs):
        late = i[1].query('time > 8')
        ax.scatter((i[0]+1)*64, late[name].mean())
        # txt = 'mean='+str(round(late[name].mean(),4))
        # ax.text((i[0]+1)*64, late[name].mean(),txt,fontsize=12)
    pdf.savefig()

with PdfPages('history.pdf') as pdf:
    plot_hist(pdf,name='x',label=r'$C_D$')
    plot_means(pdf,name='x',label=r'$C_D$')
    #plot_hist(pdf,name='y',label=r'$C_L$')
    #plot_hist(pdf,name='p',label=r'$C_P$')
    plot_hist(pdf,name='fx',label=r'$C_{Df}$')
    #plot_hist(pdf,name='fy',label=r'$C_{Lf}$')
    plot_hist(pdf,name='fpx',label=r'$C_{Dp}$')
    #plot_hist(pdf,name='fpy',label=r'$C_{Lp}$')
    #plot_hist(pdf,name='px',label=r'$C_{Pvpx}$')
    #plot_hist(pdf,name='py',label=r'$C_{Pvpy}$')
    #plot_hist(pdf,name='pp',label=r'$C_{Ppp}$')
    

    # fig, ax = plt.subplots(figsize=(8,4))
    # for name, group in grouped:
    #     arg = 2.*np.pi*name/8.
    #     cols = (1/2-np.cos(arg)/2,0.125,1/2-np.sin(arg)/2)
    #     group.plot(x='x',y='py',ax=ax,label=r'$\phi=$'+'{}/8'.format(int(name)),c=cols)
    # plt.xlabel(r'$x/c$', fontsize=12)
    # plt.ylabel(r'$\widetilde C_{Y}$', fontsize=12)
    # ax.legend(ncol=2, bbox_to_anchor=(0.4, 1.05))
    # pdf.savefig()

    # mg.plot(y=['res0','res','inf'],figsize=(8,4))
    # plt.yscale('log')
    # pdf.savefig()

    # mg.plot(y='itr',figsize=(8,4))
    # pdf.savefig()
