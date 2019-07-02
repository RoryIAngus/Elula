# Manually create role policy permissions etc
# Assign the role to the instance using the terminal


INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
AWS_REGION=ap-southeast-2

VOLUME_ID=$(aws ec2 describe-volumes --region $AWS_REGION --filter "Name=tag:Name,Values=DL-datasets-checkpoints" --query "Volumes[].VolumeId" --output text)
VOLUME_AZ=$(aws ec2 describe-volumes --region $AWS_REGION --filter "Name=tag:Name,Values=DL-datasets-checkpoints" --query "Volumes[].AvailabilityZone" --output text)



echo $INSTANCE_ID, $INSTANCE_AZ, $VOLUME_ID, $VOLUME_AZ
#>> i-01bxxxxxxxxc5bf4, ap-southeast-2, vol-xxxxxxx0072eca8, ap-southeast-2


aws ec2 attach-volume --region $AWS_REGION --volume-id $VOLUME_ID  --instance-id $INSTANCE_ID --device /dev/sdf
sleep 10

sudo mkdir /dltraining
sudo mount /dev/xvdf /dltraining
sudo chown -R ec2-user: /dltraining/
cd /dltraining

# Update the location of the where the notebook instrcutions
# create the config file
jupyter notebook --generate-config

# use sed to replace the setting with the new one
sed -i "s/#c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '\/dltraining'/g" /home/ec2-user/.jupyter/jupyter_notebook_config.py
# These are the manual commands to check or do it via vim
#vim /home/ec2-user/.jupyter/jupyter_notebook_config.py
# vim find and replace commmand
#:s/#c.NotebookApp.notebook_dir = ''/c.NotebookApp.notebook_dir = '\/dltraining'/gc
#update this in the file
## The directory to use for notebooks and kernels.
#c.NotebookApp.notebook_dir = '/dltraining'

#conda stuff
# conda install conda-build
conda update conda-build
conda update conda
conda install -c anaconda git
conda install nb_conda
conda install nb_conda_kernels  # this is needed to help manage the kernals that I need
conda install -c conda-forge jupyter_contrib_nbextensions
conda install -c conda-forge ipywidgets
# create a environment to leave base default
conda create --name working
conda activate working

# Jupyter Notebook commands
# create a new screen to hold the commands
screen -d -m -S Jupyter
# execute the commands in the "" Add a new line character to sumilate pressing enter
# this creates a notebook that can run Python at the address http://127.0.0.1:8888/tree
screen -S Jupyter -p 0 -X stuff "jupyter notebook\n"

# screen manual https://www.gnu.org/software/screen/manual/screen.html
# use this website to change the screenrs file so that it is not resized when the window is connected to https://superuser.com/questions/374752/reattaching-screen-having-irssi-running-forces-window-resize
# this is the command to edit the file with write permissions
# sudo vim /etc/screenrc
# This lists the screens that have been created. As this is run mannualy it lets the user see that it was successful
screen -ls



## the following is a few instrcutions to get you started working with the screens ##
# (note: remove the '' from the commands.
#
# help is found by 'ctrl+a' '?'

# typing 'screen -ls' porduces an output like this:
# There are screens on:
#         11010.MSREnv    (Detached)
#         21782.MongoDB   (Detached)
#         21775.Jupyter   (Detached)
# 3 Sockets in /var/run/screen/S-ec2-user.
#

# To attached to a screen use the following command and use the correct environment variable. For e.g.
# screen -dR 11010.MSREnv
# screen -dR 21782.MongoDB
# screen -dR 21775.Jupyter

# Once on the screen to return back you need to hit 'ctrl+a' followed by typing 'd'
# 'ctrl+a' 'd'
#
# To close the screen and terminate it. Type at the prompt
# 'exit'


conda install -c anaconda pandas-profiling
# conda install -c anaconda pymysql  ## This seems to break the environment when installed
conda install -seaborn
# not available on conda
pip install pygeocoder
conda install -c anaconda configparser
conda install -c conda-forge yapf
