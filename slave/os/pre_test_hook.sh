#!/bin/bash -xe

# scripts and data file
if [[ ! -e "$WORKSPACE/81-tempest.sh" ]]; then
    if [[ ! -e 81-tempest.sh ]]; then
        wget https://raw.github.com/osrg/ofaci-inst/master/slave/os/81-tempest.sh || true
    fi
    if [[ -e 81-tempest.sh && ! -e "$WORKSPACE/81-tempest.sh" ]]; then
        cp 81-tempest.sh $WORKSPACE/81-tempest.sh
    fi
fi
if [[ ! -e "$WORKSPACE/get_ofalog.sh" ]]; then
    if [[ ! -e get_ofalog.sh ]]; then
        wget https://raw.github.com/osrg/ofaci-inst/master/slave/os/get_ofalog.sh || true
    fi
    if [[ -e get_ofalog.sh && ! -e "$WORKSPACE/get_ofalog.sh" ]]; then
        cp get_ofalog.sh $WORKSPACE/get_ofalog.sh
    fi
fi
if [[ ! -e "$WORKSPACE/features.yaml" ]]; then
    if [[ ! -e features.yaml ]]; then
        wget https://raw.github.com/osrg/ofaci-inst/master/slave/os/features.yaml || true
    fi
    if [[ -e features.yaml && ! -e "$WORKSPACE/features.yaml" ]]; then
        cp features.yaml $WORKSPACE/features.yaml
    fi
fi
#if [[ -e "$WORKSPACE/features.yaml" ]]; then
#    export DEVSTACK_GATE_FEATURE_MATRIX="$WORKSPACE/features.yaml"
#fi

# tempest extras
if [[ -e "$WORKSPACE/81-tempest.sh" ]]; then
     sed -e '/ping_timeout/s/ping_timeout.*$/ping_timeout 120/' -e '/ssh_timeout/s/ssh_timeout.*$/ssh_timeout 196/' $WORKSPACE/81-tempest.sh > $WORKSPACE/81-tempest.sh.tmp
     mv $WORKSPACE/81-tempest.sh.tmp $WORKSPACE/81-tempest.sh
     sudo cp $WORKSPACE/81-tempest.sh $BASE/new/devstack/extras.d/
     sudo chown stack:stack $BASE/new/devstack/extras.d/81-tempest.sh
fi
# make local.conf
echo "[[post-config|/etc/neutron/plugins/ml2/ml2_conf.ini]]" > $WORKSPACE/local.conf
echo "[agent]" >> $WORKSPACE/local.conf
echo "l2_population=True" >> $WORKSPACE/local.conf
sudo cp $WORKSPACE/local.conf $BASE/new/devstack/
sudo chown jenkins:jenkins $BASE/new/devstack/local.conf
