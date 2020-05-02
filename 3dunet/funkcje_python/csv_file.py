import csv
import matplotlib.pyplot as plt

pathToFolder = 'wyniki\\statistics\\'
timestamp="1588318822"
filename = pathToFolder +timestamp+ "_measures.csv"

with open(filename, 'r', encoding='utf-8') as csvfile:
        epoch_list = []
        iteration_list = []
        evaluation_list = []
        loss_list = []
        with open(filename, 'r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                epoch_list.append(float(row['epoch']))
                iteration_list.append(float(row['iteration']))
                evaluation_list.append(float(row['eval_score']))
                loss_list.append(float(row['loss']))

        pathToFolder= 'wyniki\\charts\\' 
        
        lossplot = pathToFolder+timestamp+'_loss.png'
        plt.plot(iteration_list, loss_list)
        plt.xlabel("Number of iteration")
        plt.ylabel("Loss")
        plt.title("CNN: Loss vs Number of iteration")
        
        plt.savefig(lossplot)
        plt.show()

        plt.clf()

        evalplot = pathToFolder+timestamp+'_eval.png'
        plt.plot(iteration_list, evaluation_list)
        plt.xlabel("Number of iteration")
        plt.ylabel("Evaluation score")
        plt.title("CNN: Evaluation score vs Number of iteration")
        plt.savefig(evalplot)
        plt.show()