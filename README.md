# Linear Regression using Gradient Descent

![overview](https://github.com/fcastro25/Linear-regression-using-gradient-descent/blob/main/Sem%20t%C3%ADtulo.png?raw=true)

This GUI was designed to aid college professors to teach how linear regression with gradient descent works in practice.

- GUI features;

This GUI enables the user to generate scattered points randomly with linear behavior and use the gradient descent algorithm to fit iteratively a line to the generated data.

The process of generate the data can be done in two ways: by user clicking over the top graph, or automatically using the rand built in function of matlab. In the last way a buffer parameter can be set by the user to control how spread the points are. Increasing the value of this parameter will result the need to change the learning rates or the number of iterations as well, in order to fit the line properly.

Once the user provided the data, a initial line can be generated whose angular and linear coeficients will be used as a starting point by the gradient descent algorithm. Parameters related to the gradient descent approach, like, number of iterations, and learning rates can be set by the user in order to perform the curve fitting efficiently.

When the user click over the "optimize line" button the linear regression is done, and both loss function graphs and parameters table are updated/feeded in each iteration.

Obs.: Be aware that providing small learning rate will slow the process of fitting with resonable loss value. And big learning rates will make gradient descent perform big jumps disabling it to converge to the loss function minima which will mess up the fitting process too.

## Cite As

Fabricio Castro (2021). GUI that perform linear regression using gradient descent (https://www.mathworks.com/matlabcentral/fileexchange/102569-gui-that-perform-linear-regression-using-gradient-descent), MATLAB Central File Exchange. Retrieved November 25, 2021.

## Further info

For more details consider to see the video tutorial of this tool at our [YouTube channel](https://youtu.be/hTnJUbHeZ8A). Or follow discussion about it at the oficial [File Exchange Page](https://www.mathworks.com/matlabcentral/fileexchange/102569-gui-that-perform-linear-regression-using-gradient-descent).
