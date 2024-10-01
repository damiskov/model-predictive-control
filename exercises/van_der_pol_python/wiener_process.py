import numpy as np

def standard_wiener_process(T, N, nW, Ns, seed=None):
    """
    Multivariate standard Wiener process.

    Parameters
    ----------
    T : float
        Time horizon
    N : int
        Number of time points
    nW : int
        Number of Wiener processes
    Ns : int
        Number of realisations
    seed : int (optional)
        Seed for the random number generator
    
    Returns
    -------
    W : array_like
        Wiener process in time [0, T] with N points
    Tw: array_like
        Time points
    dW : array_like
        White noise used to generate the Wiener process

    """

    if seed is not None:
        np.random.seed(seed)
    
    dt = T/N
    dW = np.random.normal(0, np.sqrt(dt), size=(nW, N, Ns))
    
    try:
        # Adjust dimensions to concatenate properly - This is a weird solution, might not work. To be changed.
        # Dim W: (nW, N, Ns)    
        W_shape = (nW, N, Ns)
        # print(W_shape)
        # print(dW.shape)
        # print("dW: ", dW)
        W = np.zeros(W_shape)
        for i in range(nW):
            W[i, :, :] = np.cumsum(dW, axis=1)
    except ValueError as e:
        raise ValueError(f"Dimensionality mismatch: {e}. Expected dW shape: {(nW, N, Ns)} and matching W shape.")
        

    return W, np.linspace(0, T, N), dW