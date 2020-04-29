
import argparse
import os
import torch
import yaml
import numpy as np
import train
import predict
from funkcje_python.cross_walidation import CrossValidation

import torch
import torch.optim as optim
from torch.optim.lr_scheduler import ReduceLROnPlateau

from datasets.hdf5 import get_train_loaders
from unet3d.losses import get_loss_criterion
from unet3d.metrics import get_evaluation_metric
from unet3d.model import get_model
from unet3d.trainer import UNet3DTrainer
from unet3d.utils import get_logger

DEFAULT_DEVICE = 'cuda:0'


def load_config():
    parser = argparse.ArgumentParser(description='UNet3D training')
    parser.add_argument('--config_train', type=str, help='Path to the YAML config file', required=True)
    parser.add_argument('--config_test', type=str, help='Path to the YAML config file', required=True)
    args = parser.parse_args()
    train_config = _load_config_yaml(args.config_train)
    test_config = _load_config_yaml(args.config_test)
    # Get a device to train on
    device = train_config.get('device', DEFAULT_DEVICE)
    train_config['device'] = torch.device(device)
    test_config['device'] = torch.device(device)
    return train_config, test_config

def set_model(config, model):
    manual_seed = config.get('manual_seed', None)
    if manual_seed is not None:
        print(f'Seed the RNG for all devices with {manual_seed}')
        torch.manual_seed(manual_seed)
        # see https://pytorch.org/docs/stable/notes/randomness.html
        torch.backends.cudnn.deterministic = True
        torch.backends.cudnn.benchmark = False

        # put the model on GPUs
        print(f"Sending the model to '{config['device']}'")

        model = model.to(config['device'])
        return model

def _load_config_yaml(config_file):
    return yaml.load(open(config_file, 'r'))

def main():
    learning_rate = np.arange(0.001,0.01,0.0005)
    counter=0
    loss_criterion = eval_criterion = loaders = optimizer = lr_scheduler = trainer = None
    # Create logger
    logger = get_logger('UNet3DTrainer')

    # Load configs
    train_config, test_config = load_config()

    # Create the model
    model = get_model(train_config)

    model = set_model(train_config, model)
     # Create loss criterion
    loss_criterion = get_loss_criterion(train_config)
    # Create evaluation metric
    eval_criterion = get_evaluation_metric(train_config)
    # Create data loaders
    loaders = get_train_loaders(train_config)
    # Create the optimizer
    optimizer = train._create_optimizer(train_config, model)
    # Create learning rate adjustment strategy
    lr_scheduler = train._create_lr_scheduler(train_config, optimizer)
    
    # Create model trainer
    trainer = train._create_trainer(train_config, model=model, optimizer=optimizer, lr_scheduler=lr_scheduler,
                                loss_criterion=loss_criterion, eval_criterion=eval_criterion, loaders=loaders,
                                logger=logger)

    for x in np.nditer(learning_rate):
        x = np.round(x, 4)
        print('Learning rate:', x)
        counter+=1

        # # Crosswalidacja 
        # path_to_folder = 'dane\\256_h5\\'
        # cross_walidation = CrossValidation(path_to_folder, 1, 3, 2)
        # test_set = cross_walidation.test_filepaths
        # train_set = cross_walidation.train_filepaths
        # val_set = cross_walidation.validation_filepaths
        # train_config['loaders']['train_path'] = train_set
        # train_config['loaders']['val_path'] = val_set
        # test_config['datasets']['test_path'] = test_set

        # # Trening
        # if counter==2:
        #     path_to_resume='3dunet\\last_checkpoint.pytorch'
        #     train_config['trainer']['resume'] = path_to_resume

        # if counter>1:
        #     train_config['trainer']['iters'] = train_config['trainer']['iters'] + 12
            
       
        # Start training
        print('Rozpoczynam uczenie sieci')
        trainer.fit()
        # train.main(train_config)
        
        # Predykcja
        # print('Rozpoczynam predykcje')
        # predict.main(test_config)
        
    

if __name__ == '__main__':
    main()
