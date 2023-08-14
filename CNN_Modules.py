#=============================================================
# ME Algorithm 2023
# CNN function for 1D
# Yan-Bin Chen (陳彥賓)  yanbin@stat.sinica.edu.tw
# Institute of Statistical Science, Academia Sinica, Taipei, Taiwan. Aug, 2023 


def ME_CNN(x_train, train_label, test_array, true_answer, Num_Classes):  
    import tensorflow as tf
    import numpy
    from keras.models import Sequential
    from keras.optimizers import SGD
    from keras.utils import to_categorical
    import numpy as np
    from keras.layers import Dense, Dropout, Activation, Flatten, Convolution2D, MaxPooling2D, Conv2DTranspose, AveragePooling2D

    train_label = to_categorical(train_label, Num_Classes)
    true_answer = to_categorical(true_answer, Num_Classes)
    model = Sequential()
   
    # 1
    model.add(Convolution2D(filters=6, kernel_size=(5, 5), strides=1, activation='relu', padding="same", data_format="channels_last", input_shape=x_train[0].shape))

    # 2
    model.add(AveragePooling2D(pool_size=(2, 2), strides=2, padding="valid")) 
    
    # 3
    model.add(Convolution2D(filters=16, kernel_size=(5, 5), strides=1, activation='relu', padding="valid", data_format="channels_last"))

    # 4
    model.add(AveragePooling2D(pool_size=(2, 2), strides=2, padding="valid"))

    # 5
    model.add(Convolution2D(filters=120, kernel_size=(5, 5), strides=1, activation='relu', padding="valid", data_format="channels_last"))
    model.add(Flatten())
    
    # 6
    model.add(Dense(84,  activation='relu'))
  
    # 7
    model.add(Dense(Num_Classes, name='preds', activation='softmax'))
    model.summary()
    
    #===========================
    from keras.optimizers import Adam    
    model.compile(loss='categorical_crossentropy',
                  optimizer=Adam(lr= 0.001),
                  metrics=['accuracy'])
   

    #=== shuffle manually ========
    idx = np.arange(x_train.shape[0])
    numpy.random.shuffle(idx)
    x_train = x_train[idx]
    train_label = train_label[idx]
    #===========================
    

    from keras.callbacks import EarlyStopping, ModelCheckpoint
    earlystop = EarlyStopping(monitor='val_loss', patience=10, verbose=1)
    

    from tensorflow.keras.preprocessing.image import ImageDataGenerator    
    datagen = ImageDataGenerator(
        featurewise_center = True,
        featurewise_std_normalization = False,
        rotation_range = 30,
        zoom_range = 0.20,
        fill_mode = "nearest",
        shear_range = 0.20,
        width_shift_range = 0.2,
        height_shift_range = 0.2,
        validation_split=0.2,
        horizontal_flip = True)


    batch_size=128
    model_history = model.fit_generator(
                    generator       = datagen.flow(x_train,train_label,batch_size=batch_size,subset='training'),
                    steps_per_epoch = len(x_train)//batch_size,
                    validation_data = datagen.flow(x_train,train_label,batch_size=batch_size,subset='validation'),
                    validation_steps= len(x_train)*0.1//batch_size,
                    epochs = 80,
                    verbose = 1,
                    shuffle = True,
                    callbacks = [earlystop])
    
       
    #predict 1
    predict_percentage = model.predict(test_array)
    print(predict_percentage)
    
    #predict 2
    predict_results = model.predict_classes(test_array)
    print(predict_results)

    return predict_results, predict_percentage, model_history